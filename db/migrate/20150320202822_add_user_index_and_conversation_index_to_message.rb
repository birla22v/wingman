class AddUserIndexAndConversationIndexToMessage < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.belongs_to :user, index: true
      t.belongs_to :conversation, index: true
    end
  end
end
