# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mention_relationships,
    class_name: 'Mention',
    foreign_key: 'mention_id',
    dependent: :destroy,
    inverse_of: :mention
  has_many :mentioning_reports, through: :mention_relationships, source: :mentioned
  has_many :mentioned_relationships,
    class_name: 'Mention',
    foreign_key: 'mentioned_id',
    dependent: :destroy,
    inverse_of: :mentioned
  has_many :mentioned_reports, through: :mentioned_relationships, source: :mention

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
