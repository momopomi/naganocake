class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @orders = Order.all
    @order_details = OrderDetail.where(order_id: @order)
    @production_status = @order.order_details.pluck(:production_status)
  end

  def update
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: @order)
    if @order.update(order_status_params)
      if @order.order_status.include?("入金確認")
         @order_details.update( production_status: 1)
      end
    flash[:success] = "制作ステータスを変更しました。"
    redirect_to admin_order_path(@order)
    else
      render "show"
    end
  end

  private

  def order_status_params
    params.require(:order).permit(:order_status)
  end
end
