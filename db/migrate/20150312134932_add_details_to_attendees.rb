class AddDetailsToAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.integer :user_id
      t.integer :event_id
      # add_column :attendees, :user_id, :integer
      # add_column :attendees, :event_id, :integer
    end
  end
end
