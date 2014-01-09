class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

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

  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Dados atualizados."
      redirect_to edit_user_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario apagado."
    #flash[:success] = "Usuário apagado."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation, :cpf, :birth_date, :address, :address_num, :complement, :district, :cep, :city, :region, :phone, :cell_phone, :notifications)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to root_path, notice: "Favor acessar como usuario do Comunideia."
        # redirect_to signin_url, notice: "Favor acessar como usuário do Comunideia."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
