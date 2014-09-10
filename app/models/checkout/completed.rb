require_relative '../form'

class Completed < Form
  attribute :real_order
  attribute :real_customer

  def customer_name
    real_customer.name
  end

  def customer_email
    real_customer.email
  end

  def distributor_paypal_email
    distributor.paypal_email
  end

  def customer_address
    real_customer.address.join('<br>')
  end

  def customer_number
    real_customer.formated_number
  end

  def schedule_description
    real_order.schedule_rule
  end

  def product_name
    real_order.box.name
  end

  def payment_method
    cart.payment_method
  end

  def payment_recurring?
    !schedule_rule.one_off?
  end

  def amount_due
    cart.amount_due
  end

  def amount_due_without_symbol
    undecorated_cart = cart.decorated? ? cart.object : cart
    undecorated_cart.amount_due
  end

  def payment_title
    method = payment_method.underscore
    method = "paypal_cc" if method == "paypal" # XXX: terrible hack, can't be fucked with that now

    I18n.t(method)
  end

  def payment_message
    case payment_method
    when "bank_deposit"
      bank_information.customer_message
    when "cash_on_delivery"
      bank_information.cod_payment_message
    end
  end

  def bank_name
    bank_information.bank_name
  end

  def bank_account_name
    bank_information.bank_account_name
  end

  def bank_account_number
    bank_information.bank_account_number
  end

  def customer_number
    real_customer.formated_number
  end

  def note
    bank_information.customer_message
  end

  def distributor
    real_customer.distributor
  end

  def bank_information
    distributor.bank_information.decorate
  end

  def currency
    distributor.currency
  end

  def top_up_amount
    nil # cannot top up from the web store checkout
  end
end
