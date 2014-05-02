# encoding: UTF-8
module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to root_path, notice: "Favor acessar como usuário do Comunidéia."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def show
    @user = User.find(params[:id])
    if signed_in?
      @idea  = current_user.ideas.build
    end
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :cpf, :birthday_day, :birthday_month, :birthday_year, :address, :address_num, :complement, :district, :cep, :city, :region, :country, :phone, :cell_phone, :notifications, :facebook_association)
  end

end
