class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.sizeimg}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: :format},
             size: {less_than: Settings.length_image.megabytes, message: :less_than}                               

  scope :latest, ->{order created_at: :desc}
  scope :with_user, -> id {where user_id: id}

  def display_image
    image.variant resize_to_limit: [500, 500]
  end
end
