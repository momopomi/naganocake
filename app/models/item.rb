class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  has_one_attached :image

  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0}
  
  def with_tax_price
  (price * 1.1).floor
  end
  
  def add_tax_price
        (self.price * 1.1).round
  end
  
end


