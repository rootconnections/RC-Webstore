class StoreController < ApplicationController
  def home
    home = Home.new(
      webstore: current_webstore,
      existing_customer: current_customer,
    )

    @current_webstore_customer = home.customer.decorate

    render 'home', locals: {
      webstore_products: ProductDecorator.decorate_collection(home.products, context: { webstore: current_webstore })
    }
  end

  def start_checkout
    checkout = Checkout.new(
      webstore_id: current_webstore.id,
      existing_customer: current_customer,
    )

    return if cart_expired?("cart_id" => checkout.cart_id)

    @current_webstore_customer = checkout.customer.decorate

    product_id = params[:product_id]
    checkout.add_product!(product_id) ? successful_new_checkout(checkout) : failed_new_checkout
  end

private

  def successful_new_checkout(checkout)
    session[:cart_id] = checkout.cart_id
    redirect_to next_step
  end

  def failed_new_checkout
    flash[:alert] = t('oops')
    redirect_to webstore_path
  end

  def next_step
    return customise_order_path if current_order.customisable?

    current_webstore_customer.guest? ? authentication_path : delivery_options_path
  end
end