class UsersController < ApplicationController
  def signup
  end

  def signin
  end

  def signout
  end

  def settings
  end

  # POST /user
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
    	@user.id = @user.cpf
			current_user = User.find_by_id(@user.cpf)
			if !current_user.blank?
				#user exist with same cpf inserted
        format.html { redirect_to signup_path, notice: 'Usuario ja existe, CPF ja cadastrado, CPF: ' + current_user.cpf }
        format.json { render action: 'signup', status: :unprocessable_entity, location: @user }
	    else
	      if @user.save
	        format.html { redirect_to root_path, notice: 'User was successfully created.' }
	        format.json { render action: 'home', status: :created, location: @user }
	      else
	        format.html { redirect_to signup_path, notice: 'unprocessable_entity' }
	        format.json { render action: 'signup', status: :unprocessable_entity, location: @user }
	      end
    	end
    end
  end

  private
    def user_params
      params.require(:user).require(:cpf)
      params.require(:user).require(:email)
      params.require(:user).require(:password)
      params.require(:user).permit(:cpf, :name, :email, :password)
    end
end
