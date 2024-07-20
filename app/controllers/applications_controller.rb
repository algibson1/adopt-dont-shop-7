class ApplicationsController < ApplicationController
  before_action :find_app, only: [:show, :update]
  def show
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
    if @application.update(application_params)
      redirect_to "/applications/#{@application.id}"
    else
      redirect_to "/applications/#{@application.id}"
      flash[:alert] = "Error: #{error_message(@application.errors)}"
    end
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zipcode, :status, :reason_for_adoption)
  end

  def find_app
    @application = Application.find(params[:id])
  end
end