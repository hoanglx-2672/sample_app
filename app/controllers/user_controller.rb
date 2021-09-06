class UserController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "home.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "home.nil_user"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = "home.pleaselgin"
    redirect_to login_url
  end

  private

  def user_params
    params.require(:user)
          .permit(:email, :name, :password, :password_confirmation)
  end
end
