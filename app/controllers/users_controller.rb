class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per Settings.pagination.users_per_page
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to users_path
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "welcome_to_sample_app"
      redirect_to @user
    else
      flash[:danger] = t "create_user_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end
end
