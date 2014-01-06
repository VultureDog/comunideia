module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token


    cookies.permanent[:cpf] = user.cpf   # o ideal eh armazenar o remember_token 
    

    user.update_attributes(remember_token:User.encrypt(remember_token))
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


    #@current_user ||= User.find_by_id(remember_token)
    @current_user ||= User.find_by_id(cookies[:cpf])  # buscar por um remember_token


  end

  def sign_out
    current_user.update_attributes(remember_token:User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)


    cookies.delete(:cpf)    # nao vai precisar desse cookie quando buscar por um remember_token


    self.current_user = nil
  end

end
