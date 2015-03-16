class AddCreatorPhoneNumberToEvents < ActiveRecord::Migration
  def change
    add_column :events, :creator_phone_number, :string
  end
end
