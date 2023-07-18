class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
    @results = Pet.search(params[:search])
    @search_results = params[:search]
  end

  def new

  end

  def create
    application = Application.new(
      name: params[:name],
      street_address: params[:street_address],
      city: params[:city],
      state: params[:state],
      zipcode: params[:zipcode],
      reason_for_adoption: "N/A",
      status: "In Progress"
    )
    
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

end