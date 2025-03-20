class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout :set_layout
  AUTH_PATHS = [ "/users/login", "/users/register" ]

  private

  def set_layout
    if AUTH_PATHS.include?(request.path)
      "auth"
    else
      "application"
    end
  end
end
