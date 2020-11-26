class FollowersController < ApplicationController
  before_action :find_user

  def index
    @title = t "followers"
    @users = @user.followers
                  .page(params[:page])
                  .per Settings.pagination.users_per_page
    render "users/show_follow"
  end
end
