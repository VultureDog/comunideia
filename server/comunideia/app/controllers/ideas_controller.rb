# encoding: UTF-8
class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :set_start_step,   only: [:edit, :update]
  before_action :_is_financial_idea?,   only: [:edit, :update]

  def index
    @ideas = Idea.paginate(page: params[:page])
  end

  def new
    @idea = params.has_key?(:idea) ? current_user.ideas.new(idea_params).start : current_user.ideas.new.start
  end

  def show
    idea_id = params.has_key?(:id) ? params[:id] : random_idea_id
    @idea = Idea.find(idea_id)

    @idea_user = User.find(@idea.user_id)

    @recompenses = @idea.recompenses
    @is_financial_idea = is_financial_idea?
      
    if @is_financial_idea
      @fin_value_input = @recompenses.first.financial_value.to_i
      @investment = Investment.new(recompense_id: @recompenses.first.id)
      @recompense = @recompenses.first

      # chamar comunidea_investors apenas pra renderizar a aba de investidores
      # @idea_investors = comunidea_investors
    end

    @tab_address = params.has_key?(:tab_address) ? params[:tab_address] : nil
  end

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params).start
    @idea.financial_value_sum_accumulated = 0;
    
    @feed_items = current_user.feed.paginate(page: params[:page])

    @is_financial_idea = false
    if is_financial_idea?
      @is_financial_idea = is_financial_idea?
      @idea.createEmptyRecompense
    end

    if @idea.valid_and_set_steps && @idea.save
      @idea.step_forward

      recompenses = @idea.recompenses
      if @is_financial_idea
        recompenses.build.start
      end
    else
      flash[:error] = "Ocorreu um erro, tente criar novamente."
    end

    render 'new'
  end

  def edit
  end
  
  def update
    if @is_financial_idea
      @idea.recompenses.clear
    end

    if !@idea.save
      flash[:error] = "Ocorreu um erro, atualize o projeto novamente."
    end

    @idea.current_step = idea_params[:current_step].to_i

    parameters = idea_params
    parameters[:date_start] = parameters.has_key?(:date_start) ? DateTime.parse(parameters[:date_start]) + (Time.now.hour + 1).hour : nil
    parameters[:date_end] = parameters.has_key?(:date_end) ? DateTime.parse(parameters[:date_end]) + (Time.now.hour + 1).hour : nil

    if @idea.update_attributes(parameters)
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

    def _is_financial_idea?
      @is_financial_idea = is_financial_idea?
    end

    def is_financial_idea?
       @idea.status == Idea::COMUNIDEIA_EM_FINANCIAMENTO
    end

    def idea_params
      params.require(:idea).permit(:current_step, :name, :status, :summary, :local, :date_start, :date_end, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :consulting_project, :consulting_creativity, :consulting_financial_structure, :consulting_specific, :recompenses_attributes => [:title, :summary, :quantity, :financial_value, :date_delivery, :_destroy] )
    end

    def correct_user
      @idea = current_user.ideas.find(params[:id])
  	rescue
  	  redirect_to root_url
  	end

    def random_idea_id
      Idea.all[0 + Random.rand(Idea.count)].id
    end

    def comunidea_investors
      recompenses_ids = Idea.find(@idea).recompenses.map(&:id)
      investments_ids = Investment.where(recompense_id: recompenses_ids).map(&:user_id).uniq
      User.where(id: investments_ids)
    end

end