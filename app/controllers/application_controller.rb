# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username postcode address biography])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username postcode address biography])
  end

  def after_sign_in_path_for(resource) # rubocop:disable Lint/UnusedMethodArgument
    books_path
  end
end
