# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :set_default_request_format

  def set_default_request_format
    request.format = :json unless params[:format]
  end
end
