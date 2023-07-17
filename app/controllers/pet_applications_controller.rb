class PetApplicationsController < ApplicationController
    def create
        applicant = Application.find(params[:id])
        petapp = PetApplication.create!(
            pet_id: params[:pet_id],
            application_id: params[:id],
            status: "Pending"
            )
        redirect_to "/applications/#{applicant.id}"
    end

    def update
        pet_application = PetApplication.where(application_id: params[:id]).where(pet_id: params[:pet_id]).first
        pet_application.update!(status: params[:status])
        redirect_to "/admin/applications/#{params[:id]}"
    end
end