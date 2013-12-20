class HomeController < ApplicationController
	def home
	end
	def signup
	end

  # POST /login_session
  def create_session
  	@usrdata = params[:user]

    if @usrdata[:cpf].blank?
	    respond_to do |format|
	      format.html { redirect_to root_path, notice: "CPF nao foi inserido." }
	      format.json { render action: 'home' }
	    end
    elsif @usrdata[:password].blank?
	    respond_to do |format|
	      format.html { redirect_to root_path, notice: "Senha nao foi inserida." }
	      format.json { render action: 'home' }
    	end
    else
    	redirect_to root_path
    end
    
  end

  def current_user
    @current_user ||= User.find_by_id("teste")#(session[:user_id])
  end
  helper_method :current_user

  def signed_in?
    !!current_user
  end
  helper_method :signed_in?

  private
    def user_params
      #params.require(:user).require(:cpf)
      #params.require(:user).require(:password)
      params.require(:user).permit(:cpf, :password)
    end
end
