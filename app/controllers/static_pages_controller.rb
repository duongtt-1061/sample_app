class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed(current_user.id)
                              .includes(:user)
                              .includes(image_attachment: :blob)
                              .order_desc
                              .page(params[:page])
                              .per Settings.pagination.feed_per_page
  end

  def help; end

  def about; end

  def contact; end
end
