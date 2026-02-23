class Category < ApplicationRecord
  belongs_to :user
  has_many :events

  validates :category_name, presence: true
  validates :color_code, presence: true
end
