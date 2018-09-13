class ApplicationController < ActionController::Base
  before_action :detect_device_variant

  def get_token_list
    tokens = Token.order(symbol: :asc)  
    return tokens
  end

  def current_user
    return @current_user
  end

  def set_current_user user
    @current_user = user
  end

  def get_sellorder
    Order.order(created_at: :asc)
  end

  private

  def detect_device_variant
    request.variant = :phone if browser.device.mobile?
    request.variant = :tablet if browser.device.tablet?
  end
end
