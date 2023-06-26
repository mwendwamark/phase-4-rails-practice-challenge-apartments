class TenantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_json
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index
    tenants = Tenant.all
    render json: tenants, status: :ok, include: :apartments
  end

  def show
    tenant = finder
    render json: tenant, status: :ok
  end

  def create
    new_tenant = Tenant.create!(tenant_params)
    render json: new_tenant, status: :created
  end

  def update
    tenant = finder
    tenant.update!(tenant_params)
    render json: tenant, status: :accepted
  end

  def destroy
    tenant = finder
    tenant.destroy
    head :no_content
  end

  private

  def render_not_found_json
    render json: { error: "Apartment not found" }, status: :not_found
  end

  def render_unprocessable_entity(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def tenant_params
    params.permit(:name, :id, :age)
  end

  def finder
    tenant = Tenant.find(params[:id])
  end
end
