class Team < ActiveRecord::Base
  mount_uploader :img, ImageUploader

  scope :query, ->(query) { where('team_name like ?', "%#{sanitize_sql_like(query)}%")}
end
