class AddAttachmentPromoimageToDeals < ActiveRecord::Migration
  def self.up
    change_table :deals do |t|
      t.attachment :promoimage
    end
  end

  def self.down
    remove_attachment :deals, :promoimage
  end
end
