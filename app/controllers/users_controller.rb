class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @pagy, @users = pagy(User.all)
  end

  def show
    return if @user

    flash[:danger] = t "global.flash.not_found"
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".activation_flash"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".successful_flash"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".successful_flash"
    else
      flash[:danger] = t ".failure_flash"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".login"
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t ".unauthorized"
    redirect_to root_url
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
