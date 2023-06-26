class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_json

  def index 
    leases = Lease.all 
    render json: leases, status: :ok, except:[:created_at, :updated_at]
  end

  def show
    lease = finder
    render json: lease, status: :ok 
  end

  def create
    lease = Lease.create!(lease_params)
    render json: lease, status: :created
  end

  def destroy
    lease = finder
    lease.destroy
    head :no_content
  end

  private

  def render_not_found_json
    render json: { error: "Apartment not found" }, status: :not_found
  end

  def finder
    lease = Lease.find(params[:id])
  end

  def lease_params
    params.permit(:id, :tenant_id, :rent, :apartment_id)
  end
end
