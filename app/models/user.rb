class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :user_name, presence: true

  has_many :categories
  has_many :events

  after_create :create_default_categories

  private

  def create_default_categories
    categories.create!([
      { category_name: "仕事",         color_code: "#4aa8d8" },
      { category_name: "プライベート", color_code: "#6dbb6d" },
      { category_name: "その他",       color_code: "#eeb964" }
    ])
  end
end
