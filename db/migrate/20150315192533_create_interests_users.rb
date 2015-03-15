class CreateInterestsUsers < ActiveRecord::Migration
  def change
    create_table :interests_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :interest, index: true
    end
  end
end
