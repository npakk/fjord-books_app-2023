# frozen_string_literal: true

require 'uri'

class Report < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentions, class_name: 'Mention', foreign_key: 'mention_id', dependent: :destroy, inverse_of: :mention
  has_many :mentioning_reports, through: :mentions, source: :mentioned
  has_many :mentioned_mentions, class_name: 'Mention', foreign_key: 'mentioned_id', dependent: :destroy, inverse_of: :mentioned
  has_many :mentioned_reports, through: :mentioned_mentions, source: :mention

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mention_create!(content)
    self.mentions.each(&:destroy!)

    mentioning_reports_ids = URI.extract(content, %w[http https]).uniq.map do |url|
      next unless URI.parse(url).select(:host, :port) == ['localhost', 3000]

      # Pathが/reports/[:id]の形式ならidだけを取得する
      Regexp.last_match(1).to_i if URI.parse(url).path =~ %r{#{reports_path}/(\d+)$}
    end

    mentioning_reports_ids.each do |report_id|
      Mention.create!(mention_id: self.id, mentioned_id: report_id)
    end
  end
end
