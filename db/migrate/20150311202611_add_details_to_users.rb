class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :username, :string
  end
end
