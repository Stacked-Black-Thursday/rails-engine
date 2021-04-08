class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def pagination
    @page = params[:page] && params[:page].to_i >= 1 ? params.fetch(:page).to_i : 1
    @per_page = params[:per_page] ? params.fetch(:per_page).to_i : 20
  end
end
