class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create

    password = params[:session][:password]
    return check_activated if @user&.authenticate(password)

    flash.now[:danger] = t ".invalid_email_password_combination"
    render :new
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_activated
    if @user.activated
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t ".unactivated_flash"
      redirect_to root_url
    end
  end

  def load_user_by_mail
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
