class AddNumPeopleToEvents < ActiveRecord::Migration
  def change
    add_column :events, :num_people, :integer, :default => 0
  end
end
