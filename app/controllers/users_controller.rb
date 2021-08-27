class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :load_user, only: [:show, :destroy, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.latest.activated_true.page(params[:page]).per(Settings.perpag)
  end

  def show
    @microposts = @user.microposts.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "gmail.check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("activerecord.flash.update")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.deleted"
    else
      flash[:danger] = t "activerecord.delete!"
    end
    redirect_to users_url
  end

  def following
    @title = t "follow.following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.page(params[:page])
    render "show_follow"
  end

  def followers
    @title = t "follow.follower"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.page(params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user)
          .permit(:email, :name, :password, :password_confirmation)
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.nil"
    redirect_to root_url
  end
end
