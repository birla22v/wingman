class AddInterestsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :creator_interests, :string
  end
end
