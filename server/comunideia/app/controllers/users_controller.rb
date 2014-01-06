class UsersController < ApplicationController
  
  def signup
    @user = User.new
  end

  def settings
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Seja bem vindo a Comunideia!"
      redirect_to root_path
    else
      render 'signup'
    end

  end

  private
    def user_params
      #params.require(:user).require(:cpf)
      #params.require(:user).require(:email)
      #params.require(:user).require(:password)
      params.require(:user).permit(:cpf, :name, :email, :password)
    end
end
