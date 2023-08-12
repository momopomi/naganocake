class Order < ApplicationRecord
  VALID_POSTALCODE_REGEX = /\A\d{7}\z/
  validates :total_payment, presence: true
  validates :payment_option, presence: true
  validates :shipping_fee, presence: true
  validates :shipping_address, length: { in: 1..48 }
  validates :shipping_postcode, format: { with: VALID_POSTALCODE_REGEX }
  validates :shipping_name, length: { in: 1..32 }
  validates :order_status, presence: true

  has_many :order_details, dependent: :destroy
  belongs_to :customer
  has_many :items, through: :order_details
  
  enum payment_method: { credit_card: 0, transfer: 1 }
  enum order_status: {入金待ち:0, 入金確認:1, 製作中:2, 発送準備中:3, 発送済み:4}


  #@order.valid?を使用したいための、仮情報入力
  def temporary_information_input(current_customer_id)
    self.customer_id = current_customer_id
    self.shipping_fee = 800
    self.total_payment = 1
  end

  def order_in_postalcode_address_name(postcode, address, name)
    self.shipping_postcode = postcode
    self.shipping_address = address
    self.shipping_name = name
  end
end
