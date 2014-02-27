# encoding: UTF-8
class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :set_start_step,   only: [:edit, :update]

  def index
    @ideas = Idea.paginate(page: params[:page])
  end

  def new
    @idea = current_user.ideas.new.start
  end

  def show
    @idea = Idea.find(params[:id])
    @user = User.find(@idea.user_id)
  end

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params).start
    @idea.financial_value_sum_accumulated = 0;
    
    @feed_items = current_user.feed.paginate(page: params[:page])

    @idea.createEmptyRecompense

    if @idea.valid_and_set_steps && @idea.save
      @idea.step_forward
      recompenses = @idea.recompenses
      recompenses.build.start
    else
      flash[:error] = "Ocorreu um erro, tente criar novamente."
    end

    render 'new'
  end

  def edit
  end
  
  def update
    @idea.recompenses.clear

    if !@idea.save
      flash[:error] = "Ocorreu um erro, atualize o projeto novamente."
    end

    @idea.current_step = idea_params[:current_step].to_i

    #paramenters = idea_params
    #paramenters[:date_start] = paramenters.has_key?(:date_start) ? nil : (paramenters[:date_start] + (Time.now.hour + 1)*3600)
    #paramenters[:date_end] = paramenters.has_key?(:date_end) ? nil : (paramenters[:date_end] + (Time.now.hour + 1)*3600)

    if @idea.update_attributes(idea_params)
      flash[:success] = "Dados atualizados."
      if (@idea.current_step.to_i == 1) || (@idea.current_step.to_i == 2)
        redirect_to idea_path(@idea)
      else
        redirect_to edit_idea_path(@idea, :all => 1)
      end
    else
      render 'edit'
    end
  end

  def destroy
    @idea.destroy
    redirect_to current_user
  end

  private

    def set_start_step
      @idea.start
    end

    def idea_params
      params.require(:idea).permit(:current_step, :name, :status, :summary, :local, :date_start, :date_end, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :consulting_project, :consulting_creativity, :consulting_financial_structure, :consulting_specific, :recompenses_attributes => [:title, :summary, :quantity, :financial_value, :date_delivery, :_destroy] )
    end

    def correct_user
      @idea = current_user.ideas.find(params[:id])
  	rescue
  	  redirect_to root_url
  	end

end