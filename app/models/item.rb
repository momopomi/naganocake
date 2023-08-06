class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :price_excluding_tax, presence: true, numericality: { only_integer: true, greater_than: 0}
end
