require "SQLite3"
require "pry"
require "csv"
@fields = ["ROWID","text","date","date_read","date_delivered","is_from_me"]
@num_to_name = {}

def get_messages
  puts 'Getting messages'
  db = SQLite3::Database.new "texts.db"
  row_query = 'select ' + @fields.join(',') + ' from message'
  messages = []
  db.execute(row_query) do |row|
    message = row_to_message(row)
    message["text"].strip!
    message["text"].gsub!("'", "''")
    message["text"] = "'" + message["text"] + "'"
    chat_id = db.execute("select chat_id from chat_message_join where message_id=#{message["ROWID"]}")
    if !chat_id.nil? && chat_id != []
      chat_query = "select ROWID, chat_identifier from chat where ROWID=#{chat_id.first.first}"
      db.execute(chat_query) do |rowid, chat_identifier|
        message["number"] = "'" + chat_identifier.sub("+","") + "'"
      end
    else
      message["number"] = "''"
    end
    messages << message
  end
  get_contact_names 'contacts1.csv'
  messages
end


def row_to_message(row)
  message = {}
  @fields.zip(row).each {|key,value| message[key] = value || ""}
  message
end

def get_contact_names(filename)
  digits = '1234567890'
  file = File.open filename
  contacts_list = CSV.read file, :headers => true
  phone_fields = ['Primary Phone', 'Home Phone', 'Home Phone 2', 'Mobile Phone', 'Pager', 'Company Main Phone', 'Business Phone', 'Business Phone 2']
  contacts_list.each do |contact|
    phone_fields.each do |phone_field|
      if !contact[phone_field].nil? && contact[phone_field]!=0
        phone_num = contact[phone_field].split(//).select{|x| digits.include? x}.join
        @num_to_name[phone_num] = "'" + contact['First Name'].to_s + ' ' + contact['Last Name'].to_s + "'"
      end
    end
  end
end

# @messages = get_messages
def analyze_words
  @words = Hash.new(0)
  @bigrams = Hash.new(0)
  prev_word = ''
  @messages.each do |message|
    text_words = message['text'].downcase.gsub(/[^a-z\s]/, '').split
    text_words.each do |word|
      @words[word] += 1
      @bigrams[[prev_word, word]] += 1 if prev_word.length !=0
      prev_word = word
    end
  end
  @words
end

def create_table
  db = SQLite3::Database.new "texts.db"
  db.execute "DROP TABLE message_info_r"
  create_table_cmd = """
                     CREATE TABLE message_info_r(
                        ROWID INT,
                        text TEXT,
                        is_from_me INT,
                        date INT,
                        date_read INT,
                        date_delivered INT,
                        number TEXT,
                        date_nice TEXT,
                        sender TEXT,
                        name TEXT)
                     """.gsub "\n", " "
  puts create_table_cmd
  db.execute create_table_cmd
  @messages = get_messages
  puts "Processed messages"
  @messages.each do |message|
    insert_message = "INSERT INTO message_info_r values("
    name = @num_to_name[message["number"]] || "''"
    sender = message["is_from_me"] == '0' ? name : "'Victor Pontis'"
    values = [
             message["ROWID"],
             message["text"],
             message["is_from_me"],
             message["date"],
             message["date_read"],
             message["date_delivered"],
             message["number"],
             message["date"],
             sender,
             @num_to_name[message['number']] || "''"
              ].join ','
    insert_message << values
    insert_message << ')'
    puts insert_message
    db.execute insert_message
  end
  true
end

create_table
