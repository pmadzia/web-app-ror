class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
    redirect_to root_path if current_user&.active?
  end

  def create
    user = User.find_by(email: params[:email])

    if user.nil? || !user.authenticate(params[:password].to_s)
      flash.now[:alert] = "Invalid e-mail or password"
      return render :new, status: :unprocessable_entity
    end

    if user.blocked?
      flash.now[:alert] = "Account is blocked."
      return render :new, status: :unprocessable_entity
    end

    reset_session
    session[:user_id] = user.id
    user.update_column(:last_seen, Time.current)
    redirect_to root_path, notice: "Welcome, #{user.full_name}."
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "You have been logged out."
  end
end
