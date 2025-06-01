# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username postcode address biography])
  end

  def after_sign_in_path_for(resource)
    books_path
  end
  
  def layout
    if devise_controller?
      "user_layout"
    else
      "application"
    end
  end
end
