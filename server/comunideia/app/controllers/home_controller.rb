# encoding: UTF-8
class HomeController < ApplicationController
  def home
    @thumbnails = Idea.all
  end
end
