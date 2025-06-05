# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :icon
  validate :image_content_type

  def image_content_type
    extensions = %w[jpeg jpg gif png]
    errors.add(:icon, :icon_extension, extensions: extensions.map(&:upcase).join('・')) unless icon.content_type.in?(extensions.map { |e| "image/#{e}" })
  end
end
