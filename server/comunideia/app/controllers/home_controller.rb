# encoding: UTF-8
class HomeController < ApplicationController
  def home
    @thumbnails = Idea.all

    @user_count = User.count
    @ideas_count = Idea.count
    @dreams = Idea.find(:all, :conditions => ["status = ?", Idea::PROJECT_FINANCED]).count
    @total_investments = calculate_total_investments
  end

  def calculate_total_investments
  	total_investments = 0
    Investment.all[0..(Investment.count-1)].each do |f| total_investments += f.financial_value end
    total_investments.to_i
  end
end
