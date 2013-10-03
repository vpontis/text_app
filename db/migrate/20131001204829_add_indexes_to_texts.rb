class AddIndexesToTexts < ActiveRecord::Migration
  def change
    add_index :texts, :date
    add_index :texts, :body
    add_index :texts, :is_from_me
    add_index :texts, :name
    add_index :texts, [:name, :date]
  end
end
