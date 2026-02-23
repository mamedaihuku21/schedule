class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :notification

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :temporary, inclusion: { in: [true, false] }
end
