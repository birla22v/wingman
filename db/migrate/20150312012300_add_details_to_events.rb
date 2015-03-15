class AddDetailsToEvents < ActiveRecord::Migration
  def change
    create_table(:events) do |t|
      t.string :venue
      t.float :latitude
      t.float :longitude
      t.datetime :start_time
      t.datetime :end_time
      t.string :wingman_gender
      t.float :radius
    end
  end
end
