class Public::HomesController < ApplicationController
  def top
    # default_scope -> {order(created_at: desc)}
    @items = Item.all.order(created_at: :desc)
  end

  def about
  end
end
