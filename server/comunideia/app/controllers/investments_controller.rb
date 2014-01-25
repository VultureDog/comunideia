class InvestmentsController < ApplicationController
	before_action :signed_in_user, only: [:show, :create]

  def show
  	@recompenses = Idea.find(params[:id]).recompenses
  	@fin_value_input = @recompenses.first.financial_value.to_i
    @investment = Investment.new(recompense_id: @recompenses.first.id, user_id: current_user.id)
  end

  def create
  	@fin_value_input = params[:investment][:financial_value]
    @recompense = Recompense.find(investment_params[:recompense_id])
    @investment = @recompense.investments.new(investment_params)
  	@idea = Idea.find(@recompense.idea_id)
    @idea.financial_value_sum_accumulated += @investment.financial_value

    if @investment.save && @idea.save
	    flash[:success] = "Investimento efetuado!"
    	redirect_to @idea
    else
    	render 'investments/show'
    end
		
  end

  private

    def investment_params
      params.require(:investment).permit(:user_id, :recompense_id, :financial_value )
    end

end
