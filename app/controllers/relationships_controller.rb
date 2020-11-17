class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :get_row_relationship, only: :destroy

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.present?
      current_user.follow @user
    else
      @error = t "something_wrong"
    end
    respond_to :js
  end

  def destroy
    if @row_relationship.present?
      @user = @row_relationship.followed
      if @user.present?
        current_user.unfollow @user
      else
        @error = t "something_wrong"
      end
    else
      @error = t "something_wrong"
    end
    respond_to :js
  end

  private

  def respond_ajax_rails
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def get_row_relationship
    @row_relationship = Relationship.find_by id: params[:id]
  end
end
