class AddAgeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :creator_age, :integer
  end
end
