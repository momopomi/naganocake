class Public::OrdersController < ApplicationController

  include Public::OrdersHelper
  before_action :authenticate_customer!
  before_action :cart_check, only: [:new, :confirm, :create]

  def cart_check
    unless CartItem.find_by(customer_id: current_customer.id)
      flash[:danger] = "カートに商品がない状態です"
      redirect_to root_url
    end
  end

  def new
    @order = Order.new
  end

  def check
    @order = Order.new
    @total = 0
    @cart_items = CartItem.where(customer_id: current_customer.id)
    customer = current_customer
    address_option = params[:order][:select_address].to_i

    @order.payment_method = params[:order][:payment_option].to_i
    @order.temporary_information_input(customer.id)

    if address_option == 0
      @order.order_in_postalcode_address_name(customer.postal_code, customer.address, customer.last_name)
    end
    unless @order.present?
      flash[:danger] = "お届け先の内容に不備があります<br>・#{@order.errors.full_messages.join('<br>・')}"
      p @order.errors.full_messages
      redirect_back(fallback_location: orders_new_path)
    end
  end

   def thanks
   end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping_fare = 800
    @order.save
    cart_items = current_customer.cart_items
      cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
        @order_item = OrderDetail.new #初期化宣言
        @order_item.item_id = cart_item.item_id #商品idを注文商品idに代入
        @order_item.amount = cart_item.amount #商品の個数を注文商品の個数に代入
        @order_item.purchase_price = (cart_item.item.price*1.1).floor #消費税込みに計算して代入
        @order_item.order_id =  @order.id #注文商品に注文idを紐付け
        @order_item.save #注文商品を保存
      end
    cart_items.destroy_all
    redirect_to orders_thanks_path
  end

  def show
    @order = Order.find(params[:id])
    @order_item = @order.order_details #特定したorserからorder_items全部取得
    @total = 0
  end

  def index
    @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
  end


  private

  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :billing_amount, :payment_method)
  end

end