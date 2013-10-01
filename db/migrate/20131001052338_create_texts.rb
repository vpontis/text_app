class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.text :body
      t.boolean :is_from_me
      t.date :date
      t.string :number
      t.string :date_nice
      t.string :sender
      t.string :name

      t.timestamps
    end
  end
end
