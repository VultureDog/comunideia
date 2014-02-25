# encoding: UTF-8
class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    user, notice = User.user_login(params, auth)

    if user
      if signed_in?
        current_user.auth_provider_association(auth.provider) unless auth.blank?
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
