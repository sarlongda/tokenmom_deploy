class UserSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:user_login]
  def user_login
    if params[:login_type] == 'META_MASK'
      wallet_address = params[:wallet_address]
      nick_name = params[:nick_name]
      @user = User.find_by wallet_address: wallet_address
      if @user
        @user.nick_name = nick_name
      else
        @user = User.new(params.permit(:wallet_address, :nick_name))
      end
      @user.save
      set_current_user(@user)
    elsif params[:login_type] == 'LEDGER'
    end
    render :json => @user
  end

  def get_user
    @user = User.find_by wallet_address: params[:wallet_address]
    render :json => @user
  end

  def user_logout
    set_current_user(nil)
  end
end