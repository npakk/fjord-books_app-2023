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

    all_valid = true
    Report.transaction do
      all_valid &= @report.save
      mentioning_reports_ids(report_params[:content]).each do |report_id|
        all_valid &= Mention.create(mention_id: @report.id, mentioned_id: report_id)
      end

      raise ActiveRecord::Rollback unless all_valid
    end

    if all_valid
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # 既存の言及先と新規の言及先のIDを、集合演算の差をつかって削除するものと追加するものに分ける
    old_mentions = @report.mentioning_reports.pluck(:id)
    new_mentions = mentioning_reports_ids(report_params[:content])
    destroy_mentions = old_mentions - new_mentions
    create_mentions = new_mentions - old_mentions

    all_valid = true
    Report.transaction do
      all_valid &= @report.update(report_params)
      destroy_mentions.each do |report_id|
        all_valid &= Mention.destroy_by(mention_id: @report.id, mentioned_id: report_id)
      end
      create_mentions.each do |report_id|
        all_valid &= Mention.create(mention_id: @report.id, mentioned_id: report_id)
      end

      raise ActiveRecord::Rollback unless all_valid
    end

    if all_valid
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
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

  def mentioning_reports_ids(content)
    URI.extract(content, ['http']).uniq.map do |url|
      next unless URI.parse(url).select(:host, :port) == ['localhost', 3000]

      # Pathが/reports/[:id]の形式ならidだけを取得する
      report_id.to_i if URI.parse(url).path.match(%r{#{reports_path}/(\d+)$}) in [report_id]
    end
  end
end
