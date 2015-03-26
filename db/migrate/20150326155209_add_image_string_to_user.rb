class AddImageStringToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_string, :text, :limit => 1000000000
  end
end
