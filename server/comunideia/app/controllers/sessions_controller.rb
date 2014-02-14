# encoding: UTF-8
class SessionsController < ApplicationController

	def create
    auth = request.env["omniauth.auth"]

    user, notice = User.user_login(params, auth)

    if user
      if signed_in?
        if auth.provider = "google_oauth2"
          current_user.update_attribute(:google_plus_association, true) unless current_user.google_plus_association
        elsif auth.provider = "facebook"
          current_user.update_attribute(:facebook_association, true) unless current_user.facebook_association
        end
      else
        sign_in user
      end
      redirect_back_or root_path
    else
      flash[:notice] = notice
      redirect_to root_path
    end
	end

  def destroy
    sign_out
    redirect_to root_path
  end

  def failure
    redirect_to root_url
  end
end
