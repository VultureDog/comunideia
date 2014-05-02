# encoding: UTF-8
class RecompensesController < ApplicationController
  before_action :signed_in_user, only: [:create, :edit, :update, :destroy]

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params).start

    #@recompenses = @idea.recompenses.new(recompenses_params)
    @feed_items = current_user.feed.paginate(page: params[:page])
    
  end

  def edit

  end
  
  def update
    
  end

  def destroy
    
  end

  private

    def idea_params
      params.require(:idea).permit(:current_step, :name, :status, :summary, :local, :idea_end_date_input, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :consulting_project, :consulting_creativity, :consulting_financial_structure, :consulting_specific, :recompenses_attributes => [:title, :summary, :quantity, :financial_value, :date_delivery, :_destroy] )
    end

end