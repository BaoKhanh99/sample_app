class AccountActivationsController < ApplicationController
  before_action :load_user_by_mail, only: :edit

  def edit
    if !@user.activated && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t ".successful_activation"
      redirect_to @user
    else
      flash[:danger] = t ".fails_activation"
      redirect_to root_url
    end
  end

  private

  def load_user_by_mail
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
