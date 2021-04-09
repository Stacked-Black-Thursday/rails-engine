class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def pagination
    @page = params[:page] && params[:page].to_i >= 1 ? params.fetch(:page).to_i : 1
    @per_page = params[:per_page] ? params.fetch(:per_page).to_i : 20
  end

  def render_success(serializer, object, status = :ok)
    render json: serializer.new(object), status: status
  end

  def render_error(error, status = :bad_request)
    render json: { message: "your request cannot be completed", error: error}, status: status
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
