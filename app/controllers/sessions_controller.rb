class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      user_actived user
    else
      flash.now[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to static_pages_home_path
  end
end
