class AddAttachmentImageToThemeFiles < ActiveRecord::Migration
  def self.up
    change_table :theme_files do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :theme_files, :image
  end
end
