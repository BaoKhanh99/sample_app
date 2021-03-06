class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.digit.digit_140}
  validates(:image,
            content_type: {in: Settings.image.accept_format,
                           message: I18n.t("microposts.invalid_img_type")},
            size: {less_than: Settings.image.max_size_mb.megabytes,
                   message: I18n.t("microposts.invalid_img_size")})

  scope :newest, ->{order(created_at: :desc)}

  scope :feed, -> (id){where user_id: id}

  def display_image
    image.variant(resize_to_limit: Settings.range_500)
  end
end
