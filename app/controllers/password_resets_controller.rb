class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user,
                :check_expiration, only: [:edit, :update]
  before_action :load_user_with_email, only: [:create]

  def new; end

  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "gmail.resetpass.instructionsemail"
    redirect_to root_url
  end

  def update
    if @user.update(user_params)
      log_in @user
      @user.update_column(:reset_digest, nil)
      flash[:success] = t "gmail.resetpass.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t "user.nil"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "user.nil"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "gmail.resetpass.expired"
    redirect_to new_password_reset_url
  end

  def load_user_with_email
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    return if @user

    flash.now[:danger] = t "activerecord.flash.gmail.notfound"
    render :new
  end
end
