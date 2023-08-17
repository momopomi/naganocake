class Public::CartItemsController < ApplicationController

 before_action :authenticate_customer!

  def index
    @cart_items = CartItem.where(customer_id: current_customer.id)
    #@cart_itmes = current_customer.cart_items.all
    @total = 0


  end

  def create
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      @cart_items = current_customer.cart_items.all

      @cart_items.each do |cart_item|
        if cart_item.item_id==@cart_item.item_id
          new_amount = @cart_item.amount + cart_item.amount
          cart_item.update_attribute(:amount, new_amount)
          @cart_item.delete
          redirect_to cart_items_path
        end
      end
      
      if @cart_item.save
        flash[:success] = "カートに追加しました"
        redirect_to cart_items_path
      end

  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      flash[:success] = "個数を変更しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "正しい個数を入力してください"
      redirect_back(fallback_location: root_path)
    end
    @cart_items=current_customer.cart_items.all
        @cart_items.each do |cart_item|
          if cart_item.item_id==@cart_item.item_id
          new_amount = cart_item.amount
          cart_item.update_attribute(:amount, new_amount)

          end
        end
  end

  def destroy_all
    #@cart_itmes = current_customer.cart_items.all
    CartItem.where(customer_id: current_customer.id).destroy_all
    flash[:success] = "カートの中身を空にしました"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash[:success] = "選択いただいたカートを空にしました"
    redirect_back(fallback_location: root_path)
  end



  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end