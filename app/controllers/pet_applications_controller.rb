class PetApplicationsController < ApplicationController
  def create
    PetApplication.create(pet_id: params[:pet_id],application_id: params[:id])
    redirect_to "/applications/#{params[:id]}"
  end

  def update
    pet_application = PetApplication.find_by(application_id: params[:app_id], pet_id: params[:pet_id])
    pet_application.update(status: params[:status])
    redirect_to "/admin/applications/#{params[:app_id]}"
  end
end