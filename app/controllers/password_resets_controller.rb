class PasswordResetsController < ApplicationController
  before_action :load_user, :check_user_valid, :check_password_expired,
                only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".instruction"
      redirect_to root_url
    else
      flash.now[:danger] = t ".not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".error"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def check_user_valid
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".user_invalid"
    redirect_to root_url
  end

  def check_password_expired
    return unless @user.password_reset_expired?

    flash[:danger] = t ".expired"
    redirect_to new_password_reset_url
  end
end
