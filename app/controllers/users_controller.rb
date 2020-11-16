class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated
                 .page(params[:page])
                 .per Settings.pagination.users_per_page
  end

  def new
    @user = User.new
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "profile_update_failed"
      render :edit
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_mail_to_activate"
      redirect_to root_path
    else
      flash[:danger] = t ".create_account_faild"
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "something_wrong"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "something_wrong"
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "you_dont_have_permision"
    redirect_to root_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = "something_wrong"
    redirect_to root_path
  end
end
