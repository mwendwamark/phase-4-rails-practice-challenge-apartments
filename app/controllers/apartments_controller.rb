class ApartmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_json
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index 
    apartments= Apartment.all 
    render json: apartments , status: :ok , except: [:created_at, :updated_at]
  end

  def show 
    apartment = finder 
    render json: apartment, status: :ok, except: [:created_at, :updated_at]
  end

  def create 
    apartment = Apartment.create!(apartment_params)
    render json: apartment, status: :created
  end

  def update 
    apartment = finder 
    apartment.update!(apartment_params)
    render json: apartment, status: :accepted 
  end

  def destroy 
    apartment = finder 
    apartment.destroy
    head :no_content 
  end

  private

  def render_not_found_json
    render json: { error: "Apartment not found" }, status: :not_found
  end

  def render_unprocessable_entity(invalid)
    render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def finder 
    apartment = Apartment.find(params[:id])
  end

  def apartment_params 
    params.permit(:id, :number)
  end
end
