class Team < ActiveRecord::Base
  mount_uploader :img, ImageUploader

  has_many :team_users, dependent: :destroy

  validates :team_name, presence: true

  scope :query, ->(query) { where('team_name like ? OR body like ?', "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%")}
end
