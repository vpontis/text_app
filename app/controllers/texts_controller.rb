class TextsController < ApplicationController
  def index
    @texts = Text.all.order('date asc').paginate(page: params[:page])
    @top_names = Text.select('name, count(*) as id').group('name').order('count(*) desc').map {|text| [text.name, text.id]}
  end

  def conversation
    @texts = Text.where('name=?', params[:name]).paginate(page: params[:page])
    @name = params[:name]
    render 'conversation'
  end

  def add_contact_names
    contact_names_file = params['contact_names_file']

    owner_name = params['name']

    num_to_name = get_contact_names(contact_names_file.path)

    ActiveRecord::Base.transaction do
      Text.all.each do |text|
        logger.debug num_to_name
        if !num_to_name[text.number].nil?
          text.name = num_to_name[text.number]
          text.sender = text.name unless text.is_from_me
          text.save!
        end
      end
    end

    redirect_to texts_path
  end

  def upload_texts_db
    # TODO read from file without saving it
    texts_db_file = params['texts_db_file']
    texts_db_file_name = texts_db_file.original_filename

    owner_name = params['name']

    directory = 'public/'
    path = File.join(directory, texts_db_file_name)

    File.open(path, "wb") { |f| f.write(texts_db_file.read) }

    messages = get_messages(texts_db_file.path, owner_name)

    ActiveRecord::Base.transaction do
      messages.each do |message|
        Text.new(message).save!
      end
    end 

    logger.debug texts_db_file
    logger.debug messages[1]
    logger.debug owner_name

    redirect_to texts_path
  end

  def delete_texts
    Text.destroy_all
    flash[:success] = "Deleted texts"
    redirect_to '/upload'
  end
end
