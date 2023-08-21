class Order < ApplicationRecord
  VALID_POSTALCODE_REGEX = /\A\d{7}\z/
  validates :billing_amount, presence: true
  validates :payment_method, presence: true
  validates :shipping_fare, presence: true
  validates :address, length: { in: 1..48 }
  validates :postal_code, format: { with: VALID_POSTALCODE_REGEX }
  validates :name, length: { in: 1..32 }


  has_many :order_details, dependent: :destroy
  belongs_to :customer
  has_many :items, through: :order_details


  enum payment_method: { クレジットカード: 0, 銀行振込: 1 }

  #@order.valid?を使用したいための、仮情報入力
  def temporary_information_input(current_customer_id)
    self.customer_id = current_customer_id
    self.shipping_fare = 800
    self.billing_amount = 1
  end

  def order_in_postalcode_address_name(postal_code, address, name)
    self.postal_code = postal_code
    self.address = address
    self.name = name
  end
  
 

  def subtotal
    item.with_tax_price * amount
  end
end
