class AddGenderAndUsernameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :creator_gender, :string
    add_column :events, :creator_name, :string
  end
end
