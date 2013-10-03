class AddColumnSecondsToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :seconds, :integer
  end
end
