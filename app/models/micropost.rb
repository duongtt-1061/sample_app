class Micropost < ApplicationRecord
  MICROPOST_PERMIT = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
             length: {maximum: Settings.validates.micropost.max_content}
  validates :image, content_type: {in: Settings.content_type_image.split(" "),
                                   message: I18n.t("danger_format_image")},
                    size: {less_than: Settings.size_of_file.image.megabytes,
                           message: I18n.t("danger_size_image_too_large")}

  scope :feed_for_user, (lambda do |user_id, following_ids|
    return unless user_id

    following_ids << user_id
    where("user_id IN (:following_ids)", following_ids: following_ids)
  end)
  scope :order_desc, ->{order created_at: Settings.order_by.created_microposts}

  delegate :name, to: :user

  def display_image
    image.variant resize_to_limit: [Settings.resize.post_in_feed.width,
                                    Settings.resize.post_in_feed.length]
  end
end
