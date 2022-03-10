class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    password = params[:session][:password]
    return check_activated if user&.authenticate(password)

    flash.now[:danger] = t ".invalid_email_password_combination"
    render :new
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_activated user
    if user.activated
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t ".unactivated_flash"
      redirect_to root_url
    end
  end
end
