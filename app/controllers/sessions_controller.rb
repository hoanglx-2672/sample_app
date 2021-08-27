class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user.try(:authenticate, params[:session][:password])
      user_active? user
    else
      flash.now[:danger] = t "activerecord.errors.user.login.invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path, success: t("home.logout")
  end
end
