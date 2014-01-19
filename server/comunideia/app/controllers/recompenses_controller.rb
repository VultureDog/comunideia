class RecompensesController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params)

    #@recompenses = @idea.recompenses.new(recompenses_params)
    @feed_items = current_user.feed.paginate(page: params[:page])
    
  end

  def destroy
    
  end

  private

    def idea_params
      params.require(:idea).permit(:name, :summary, :local, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :recompenses_attributes => [:title, :summary, :quantity, :financial_value] )
    end

end