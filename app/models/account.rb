class Account < ActiveRecord::Base
  mount_uploader :img, ImageUploader

  validates :user_name, length: { minimum: 3 }
end
