class StaticPagesController < ApplicationController
  def upload_texts
  end
  def process_file
    file = params['file']
    logger.debug file
    name = file.original_filename
    logger.debug file.headers
    logger.debug file.tempfile.path
    directory = 'public/'
    path = File.join(directory, name)
    saved_file = File.open(path, "wb") { |f| f.write(file.read) }

    messages = get_messages(path)
    logger.debug messages[1]
    render 'upload_texts'
  end
end
