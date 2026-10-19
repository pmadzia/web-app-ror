class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      redirect_to login_path, notice: "Registration was successful."
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email, "is already registered")
    render :new, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:user).permit(:full_name, :email, :job_position, :password)
  end
end
