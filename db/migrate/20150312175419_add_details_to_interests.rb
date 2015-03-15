class AddDetailsToInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :name
      t.integer :interest_id
    end
  end
end
