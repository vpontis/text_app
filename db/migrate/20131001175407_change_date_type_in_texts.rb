class ChangeDateTypeInTexts < ActiveRecord::Migration
  def self.up
    change_column :texts, :date, :datetime
  end
  def self.down
    change_column :texts, :date, :date
  end
end
