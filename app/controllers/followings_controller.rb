class FollowingsController < ApplicationController
  before_action :find_user

  def index
    @title = t "following"
    @users = @user.following
                  .page(params[:page])
                  .per Settings.pagination.users_per_page
    render "users/show_follow"
  end
end
