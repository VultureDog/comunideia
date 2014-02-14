# encoding: UTF-8
class User < ActiveRecord::Base
	
  NAME = "Nome"
  NAME_MAX_CHARS = 50
  validates :name,  presence: { message: "#{NAME} (nome está em branco, você pode nos contar qual é seu nome? Ex: João Silva)" }, length: { maximum: NAME_MAX_CHARS, message: "#{NAME} (nome está muito longo, se preciso pode inserir apenas abreviações de sobrenome. Máximo de #{NAME_MAX_CHARS} caracteres)" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  EMAIL = "E-mail"
  EMAIL_CONFIRMATION = "#{EMAIL}: confirmação"
  validates :email, presence: { message: "#{EMAIL} (e-mail está em branco, você pode nos contar qual e-mail você usa? Ex: atendimento@vulturedog.com)" }, format: { with: VALID_EMAIL_REGEX, message: "#{EMAIL} (e-mail está em um formato que nao consideramos válido. Ex: atendimento@vulturedog.com)" },
                    uniqueness: { case_sensitive: false, message: "#{EMAIL} (já existe esse e-mail cadastrado, você usa algum outro que poderia cadastrar?)" }, confirmation: { message: "#{EMAIL} (os campos '#{EMAIL}' e '#{EMAIL_CONFIRMATION}' precisam ser exatamente iguais)" }
  
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  PASSWORD = "Senha"
  PASSWORD_CONFIRMATION = "#{PASSWORD}: confirmação"
  PASSWORD_MIN_CHARS = 8
  has_secure_password
  validates :password, presence: { message: "#{PASSWORD} (senha está em branco, você pode inserir uma senha para sua segurança?)" }, length: { minimum: PASSWORD_MIN_CHARS, message: "#{PASSWORD} (senha está curta, a senha precisa ter no mínimo #{PASSWORD_MIN_CHARS} digitos)" }

  has_many :ideas, dependent: :destroy

  CPF = "CPF"
  BIRTH_DATE = "Data de nascimento"
  ADDRESS = "Endereço"
  ADDRESS_NUMBER = "número"
  ADDRESS_COMPLEMENT = "complemento"
  ADDRESS_NEIGHBORHOOD = "Bairro"
  ADDRESS_CITY = "Cidade"
  ADDRESS_STATE = "Estado"
  ADDRESS_CEP = "CEP"
  ADDRESS_CELLPHONE = "Celular"
  ADDRESS_PHONE = "Telefone fixo"
  NOTIFICATIONS_AND_UPDATES = "Gostaria de receber notificações e atualizações?"
  FACEBOOK_ASSOCIATION = "Gostaria de associar sua conta do Facebook com sua conta do Comunidéia?"
  GOOGLE_PLUS_ASSOCIATION = "Gostaria de associar sua conta do Google+ com sua conta do Comunidéia?"
  SAVE_STRING = "Salvar"
  ENTER_STRING = "Acessar"




  def feed
    Idea.where("user_id = ?", id)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def User.user_login(create_params, auth)

    # login with platform user
    if create_params.has_key?(:session)
      session_params = create_params[:session]
      user = User.find_by_email(session_params[:email].downcase)
      if user && user.authenticate(session_params[:password])
        return user, ""
      else
        return nil, "Combinação e-mail/senha inválida"
      end

    # login with auth user
    elsif !auth.blank?
      user = User.find_by_email(auth.info.email)
      if user
        if auth.provider = "google_oauth2"
          user.google_plus_association = true
        elsif auth.provider = "facebook"
          user.facebook_association = true
        end
      else
        attribute_association = 
        if auth.provider = "google_oauth2"
          attribute_association = :google_plus_association
        elsif auth.provider = "facebook"
          attribute_association = :facebook_association
        end
        user = User.new(email: auth.info.email, name:auth.info.name, password: ('a'..'z').to_a.shuffle[0,20].join, attribute_association => true)
      end
      return user, ""
    end

  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
