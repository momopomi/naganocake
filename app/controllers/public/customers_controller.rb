class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  
  
  
  def show
    @customer = current_customer
  end
  
  def edit
    @customer = current_customer
  end
  
  def update
    
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
        flash[:notice] = "edit successfully"
        redirect_to customers_path(@customer.id)
    else
        render :edit
    end
  end
  
  def check
    
  end
  
  def withdraw
    @customer = current_customer
    @customer.is_deleted = true
    if @customer.save
      reset_session
      redirect_to root_path
    end
  end
  
  


  private

  
end
