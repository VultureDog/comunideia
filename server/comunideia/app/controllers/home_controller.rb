class HomeController < ApplicationController
  def home
    @thumbnails = Idea.all
  end
end
