class Event < ActiveRecord::Base
  has_many :event_comments, dependent: :destroy
  has_many :event_participants, dependent: :destroy
end
