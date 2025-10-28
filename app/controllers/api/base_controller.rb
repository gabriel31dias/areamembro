class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  private

  def render_success(data = nil, message = nil, status = :ok)
    response = { success: true }
    response[:data] = data if data
    response[:message] = message if message
    render json: response, status: status
  end

  def render_error(message, code = nil, details = nil, status = :unprocessable_entity)
    response = {
      success: false,
      error: {
        message: message
      }
    }
    response[:error][:code] = code if code
    response[:error][:details] = details if details
    render json: response, status: status
  end

  def render_unauthorized(message = "Credenciais inválidas")
    render_error(message, "INVALID_CREDENTIALS", nil, :unauthorized)
  end
end