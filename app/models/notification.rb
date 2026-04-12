class Notification < ApplicationRecord
  belongs_to :event

  validates :notify_at, presence: true
end
