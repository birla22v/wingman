class AddStartTimeStringAndEndTimeStringToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_time_string, :string
    add_column :events, :end_time_string, :string
  end
end
