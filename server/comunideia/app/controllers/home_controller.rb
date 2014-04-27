# encoding: UTF-8
class HomeController < ApplicationController
  def home
#    @thumbnails = Idea.all

    @ideas_COMUNIDEIA_EM_ACAO = Idea.find(:all, :conditions => ["status = ?", Idea::COMUNIDEIA_EM_ACAO])
    @ideas_COMUNIDEIA_EM_FINANCIAMENTO = Idea.find(:all, :conditions => ["status = ?", Idea::COMUNIDEIA_EM_FINANCIAMENTO])
 
    @user_count = User.count
    @ideas_count = Idea.count
    @dreams = Idea.find(:all, :conditions => ["status = ?", Idea::PROJECT_FINANCED]).count
    @total_investments = calculate_total_investments
  end

  private
  
	  def calculate_total_investments
	  	total_investments = 0

      Idea.find(:all, :conditions => ["status = ?", Idea::PROJECT_FINANCED]).each do |financed_idea|
       total_investments += financed_idea.financial_value_sum_accumulated
      end

	    total_investments.to_i
	  end
end
