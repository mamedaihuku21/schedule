class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :notification, dependent: :destroy

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
