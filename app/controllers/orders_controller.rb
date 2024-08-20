class OrdersController < ApplicationController
  include OrdersHelper
  before_action :set_default_data, :set_order_items, only: %i(order_info create)

  def order_info
    @order = Order.new
  end

  def create
    @order = @current_user.orders.new order_params
    @order.total = calculate_total_amount @order_items_ids

    if @order.valid?
      process_order
    else
      flash.now[:error] = t "orders.order_info.messages.failed"
      render :order_info, status: :unprocessable_entity
    end
  end

  private

  def set_default_data
    @current_user = current_user
    @addresses = @current_user.addresses.sort_by_time
    @address = @current_user.addresses.default_or_latest
  end

  def set_order_items
    # order_items_ids = cookies[:cartitemids].split(",").map(&:to_i)
    @order_items_ids = [1, 2, 3]
    @order_items = @order_items_ids.map do |id|
      cart = Cart.find_by(id:)
      product = Product.find_by id: cart.product_id
      item_total = calculate_item_total(cart)
      {cart:, product:, item_total:}
    end
  end

  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def add_order_items
    @order_items.each do |item|
      @order.order_items.build(
        product_id: item[:product].id,
        quantity: item[:cart].quantity,
        price: item[:product].price
      )
    end
  end

  def process_order
    add_order_items
    if @order.save
      flash[:success] = t "orders.order_info.messages.success"
      redirect_to root_path
    else
      render :order_info, status: :unprocessable_entity
    end
  end
end