class PasswordResetsController < ApplicationController
  before_action :get_user,:valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".sent_email_reset_password"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("cannot_be_empty")
      render :edit
    elsif @user.update users_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "password_has_been_reset"
      redirect_to @user
    else
      flash[:danger] = t "password_reset_failed"
      render :edit
    end
  end

  private

  def users_params
    params.require(:user).permit User::USER_PERMIT_FOR_RESET_PW
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "something_wrong"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "something_wrong"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset_has_expired"
    redirect_to new_password_reset_url
  end
end
