# encoding: UTF-8
class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index]
  before_action :correct_user_for_destroying, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    #@feed_items = @user.feed.paginate(page: params[:page])
    @thumbnails = @user.feed
  end

  def signup
    @user = params.has_key?(:user) ? User.new(user_params) : User.new
  end

  def settings
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Seja bem vindo a Comunidéia!"
      redirect_to @user
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
    if !current_user.admin?
      sign_out
    end

    User.find(params[:id]).destroy
    flash[:success] = "Usuário apagado."

    if signed_in? # if it's signed_in, it must be admin, so redirect to users_url
      redirect_to users_url
    else
      redirect_to root_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation, :cpf, :birth_date, :address, :address_num, :complement, :district, :cep, :city, :region, :phone, :cell_phone, :notifications, :facebook_association)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def correct_user_for_destroying
      @user = User.find(params[:id])
      redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
