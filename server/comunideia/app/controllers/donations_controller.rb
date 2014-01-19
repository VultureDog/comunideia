class DonationsController < ApplicationController
	before_action :signed_in_user, only: [:show, :create]

  def show
    @idea = Idea.find(params[:id])
    @donation = @idea.donations.new(idea_id: @idea.id, user_id: current_user.id)
  end

  def create
    @idea = Idea.find(params[:donation][:idea_id])
    @donation = @idea.donations.new(donation_params)
    @donation.date = Time.now;
    @idea.financial_value_sum_accumulated += @donation.financial_value

    if @donation.save && @idea.save
	    flash[:success] = "Investimento efetuado!"
    	redirect_to @idea
    else
    	render 'donations/show'
    end
		
  end

  private

    def donation_params
      params.require(:donation).permit(:user_id, :idea_id, :financial_value )
    end

end
