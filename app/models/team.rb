class Team < ActiveRecord::Base
  mount_uploader :img, ImageUploader

  has_many :team_users, dependent: :destroy

  scope :query, ->(query) { where('team_name like ?', "%#{sanitize_sql_like(query)}%")}
end
