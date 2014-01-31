# encoding: UTF-8
class SessionsController < ApplicationController

	def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash[:error] = 'Combinação e-mail/senha inválida'
      redirect_to root_path
    end
	end

  def destroy
    sign_out
    redirect_to root_path
  end

end
