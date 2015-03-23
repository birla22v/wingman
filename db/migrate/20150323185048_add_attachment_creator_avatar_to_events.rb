class AddAttachmentCreatorAvatarToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :creator_avatar
    end
  end

  def self.down
    remove_attachment :events, :creator_avatar
  end
end
