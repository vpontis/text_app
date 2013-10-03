class TextsController < ApplicationController
  def index
    @texts = Text.all
  end

  def conversation
    @texts = Text.where('name=?', params[:name])
    render 'index'
  end

  def process_file
    file = params['file']
    file_name = file.original_filename

    owner_name = params['name']

    directory = 'public/'
    path = File.join(directory, file_name)

    File.open(path, "wb") { |f| f.write(file.read) }

    messages = get_messages(path, owner_name)

    ActiveRecord::Base.transaction do
      messages.each do |message|
        Text.new(message).save!
      end
    end 

    logger.debug file
    logger.debug messages[1]
    logger.debug owner_name

    redirect_to texts_path
  end
end
