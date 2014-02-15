# encoding: UTF-8
class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def index
    @ideas = Idea.paginate(page: params[:page])
  end

  def new
    @idea = current_user.ideas.new
    @idea.recompenses.build
  end

  def show
    @idea = Idea.find(params[:id])
    @user = User.find(@idea.user_id)
  end

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params)
    @idea.financial_value_sum_accumulated = 0;
    @idea.date_start = @idea.date_start + (Time.now.hour + 1)*3600
    @idea.date_end = @idea.date_end + (Time.now.hour + 1)*3600
    @idea.createEmptyRecompense
    @feed_items = current_user.feed.paginate(page: params[:page])

    if @idea.save
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @idea.update_attributes(idea_params)
      flash[:success] = "Dados atualizados."
      redirect_to edit_idea_path(@idea)
    else
      render 'edit'
    end
  end

  def destroy
    @idea.destroy
    redirect_to current_user
  end

  private

    def idea_params
      params.require(:idea).permit(:name, :summary, :local, :date_start, :date_end, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :recompenses_attributes => [:title, :summary, :quantity, :financial_value, :date_delivery, :_destroy] )
    end

    def correct_user
      @idea = current_user.ideas.find(params[:id])
  	rescue
  	  redirect_to root_url
  	end
end