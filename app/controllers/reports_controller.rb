# frozen_string_literal: true

require 'uri'

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    begin
      Report.transaction do
        @report.save!
        mention_create!(report_params[:content])
      end
    rescue
      render :new, status: :unprocessable_entity
    else
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    end
  end

  def update
    begin
      Report.transaction do
        @report.mentions.each(&:destroy!)
        @report.update!(report_params)
        mention_create!(report_params[:content])
      end
    rescue
      render :edit, status: :unprocessable_entity
    else
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def mention_create!(content)
    mentioning_reports_ids = URI.extract(content, %w[http https]).uniq.map do |url|
      next unless URI.parse(url).select(:host, :port) == ['localhost', 3000]

      # Pathが/reports/[:id]の形式ならidだけを取得する
      Regexp.last_match(1).to_i if URI.parse(url).path =~ %r{#{reports_path}/(\d+)$}
    end

    mentioning_reports_ids.each do |report_id|
      Mention.create!(mention_id: @report.id, mentioned_id: report_id)
    end
  end
end
