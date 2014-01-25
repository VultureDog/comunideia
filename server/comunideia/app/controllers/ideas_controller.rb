class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @ideas = Idea.paginate(page: params[:page])
  end

  def new
    flash[:error] = params
    @idea = current_user.ideas.new
    @idea.recompenses.build
  end

  def show
    @idea = Idea.find(params[:id])
  end

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params)
    @idea.financial_value_sum_accumulated = 0;
    @feed_items = current_user.feed.paginate(page: params[:page])
    if @idea.save
      redirect_to current_user
    else
      render 'users/show'
    end
  end

  def destroy
    @idea.destroy
    redirect_to current_user
  end

  private

    def idea_params
      params.require(:idea).permit(:name, :summary, :local, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :recompenses_attributes => [:title, :summary, :quantity, :financial_value] )
    end

    def correct_user
	  @idea = current_user.ideas.find(params[:id])
  	rescue
  	  redirect_to root_url
  	end
end