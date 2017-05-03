class Group < ActiveRecord::Base
  mount_uploader :img, ImageUploader
end
