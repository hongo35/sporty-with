class Event < ActiveRecord::Base
  has_many :event_comments, dependent: :destroy
end
