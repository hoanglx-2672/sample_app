module SessionsHelper
  def log_out
    session[:user_id] = nil
  end

  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def user_active? user
    session[:user_id] = user.id
    log_in(user)
    redirect_to root_path, notice: t("hello")
  end
end