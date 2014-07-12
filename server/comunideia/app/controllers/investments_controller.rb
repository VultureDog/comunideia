# encoding: UTF-8
class InvestmentsController < ApplicationController
  before_action :signed_in_for_investment, only: [:create, :new]

  def new
    flash[:success] = "Ficamos gratos pelo depósito em nossa confiança e pelo investimento!"
    redirect_to investment_first_step_path( :investment => {:recompense_id => investment_params[:recompense_id], :financial_value => investment_params[:financial_value]} )
  end

  def create
    if @investment.save && @idea.save
      payment_params = params
      payment_params[:investment][:investment_id] = @investment.id
      redirect_to investment_second_step_path( params )
    else
      render 'new'
    end
		
  end

  private

    def investment_params
      params.require(:investment).permit(:user_id, :recompense_id, :financial_value, :payment_type)
    end

    def signed_in_for_investment
      @fin_value_input = investment_params[:financial_value]
      @recompense = Recompense.find(investment_params[:recompense_id])
      @investment = Investment.new(investment_params)
      @idea = Idea.find(@recompense.idea_id)
      @recompenses = @idea.recompenses
      @idea_user = User.find(@idea.user_id)
      @idea_content_paragraphs = @idea.idea_content.split("\r\n", 6)
      @img_pgs = []
      @img_pgs[0] = @idea.img_pg_1 unless @idea.img_pg_1.nil?
      @img_pgs[1] = @idea.img_pg_2 unless @idea.img_pg_2.nil?
      @img_pgs[2] = @idea.img_pg_3 unless @idea.img_pg_3.nil?
      @img_pgs[3] = @idea.img_pg_4 unless @idea.img_pg_4.nil?

      if @fin_value_input.blank?
        flash[:error] = "Valor em branco."
        render 'ideas/show'
      elsif (@fin_value_input.to_i < @recompense.financial_value.to_i)
        flash[:error] = "Valor inválido. O valor financeiro que está investindo é R$" + @fin_value_input.to_s + " e a recompensa selecionada é '" + @recompense.title + "' de valor financeiro R$" + @recompense.financial_value.to_i.to_s + "."
        render 'ideas/show'
      elsif !signed_in?
        flash[:notice] = "Favor acessar como usuário do Comunidéia."
        render 'ideas/show'
      end
    end

end
