class Team < ActiveRecord::Base
  mount_uploader :img, ImageUploader
end
