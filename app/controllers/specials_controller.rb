class SpecialsController < ApplicationController

	def index
		# need to test if moving the issue_id inside the if statement effects anything
		@report_type = params[:report_type] if params[:report_type]
		@car_id = params[:car_id] if params[:car_id]
		@token = params[:token] if params[:token]
		if @report_type == "Issue"
			@issue_id = params[:issue_id] if params[:issue_id]
			@service = Repair.new
			@service.repairable = Issue.find(params[:issue_id])
			p @service.repairable
		elsif @report_type == "Maintenance"
			@service = Maintenance.new
		end
	end

	def show
	end

	def create
		# NEED TO SORT THIS TO INCLUDE MAINTENANCE
		# already added form to index
		# need to include maintenance strong_params 
		p '*' * 80
		p params
		p '*' * 80

		if params[:repair]
			@car = Car.find(params[:repair][:car_id])
			@issue = Issue.find(params[:repair][:issue_id])
			@service = Repair.new(repair_params)
			@service.repairable = @issue
		elsif params[:maintenance]
			@car = Car.find(params[:maintenance][:car_id])
			@service = Maintenance.new(maintenance_params)
			@service.car_id = @car.id
		end
		p '*' * 80
		 p @service
		 p '*' * 80
		if @service.save
			render 'thanks'
		else
			@errors = @service.errors.full_messages
			redirect_to request.original_url
			# need to fix the redirect_to
		end	
	end

	private
	def repair_params
    params.require(:repair).permit(:title, :description, :mileage, :date_completed)
  end

  def maintenance_params
  	params.require(:maintenance).permit(:title, :description, :mileage, :date_completed, :car_id)
  end
end