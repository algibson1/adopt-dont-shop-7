class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    @results = Pet.search(params[:search]) if params[:search]
  end

  def new

  end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  def update
    application = Application.find(params[:id])
    if params[:reason_for_adoption].empty?
      redirect_to "/applications/#{application.id}"
      flash[:alert] = "Please input why you would be a good home"
    else
      application.update(
        status: "Pending",
        reason_for_adoption: params[:reason_for_adoption]
      )
      redirect_to "/applications/#{application.id}"
    end
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zipcode)
  end
end