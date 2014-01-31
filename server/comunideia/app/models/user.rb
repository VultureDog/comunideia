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
  has_secure_password
  validates :password, presence: { message: "#{PASSWORD} (senha está em branco, você pode inserir uma senha para sua segurança?)" }, length: { minimum: 6, message: "#{PASSWORD} (senha está curta, a senha precisa ter no mínimo 6 digitos)" }

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

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
