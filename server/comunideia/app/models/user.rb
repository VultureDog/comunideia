# encoding: UTF-8
class User < ActiveRecord::Base
  
  attr_accessor :birthday_day, :birthday_month, :birthday_year
	
  include MultiStepModel

  USER_CONFUSION = "Ocorreu uma confusão por aqui. Envie-nos um e-mail, investigaremos para descobrir o que aconteceu!"
  validates :id, presence: { message: USER_CONFUSION }, if: :step2?

  NAME = "Nome"
  NAME_MAX_CHARS = 50
  validates :name,  presence: { message: "#{NAME} (nome está em branco, você pode nos contar qual é seu nome? Ex: João Silva)" }, length: { maximum: NAME_MAX_CHARS, message: "#{NAME} (nome está muito longo, se preciso pode inserir apenas abreviações de sobrenome. Máximo de #{NAME_MAX_CHARS} caracteres)" }, if: :valid_steps_1_2?
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  EMAIL = "E-mail"
  validates :email, presence: { message: "#{EMAIL} (e-mail está em branco, você pode nos contar qual e-mail você usa? Ex: atendimento@vulturedog.com)" }, format: { with: VALID_EMAIL_REGEX, message: "#{EMAIL} (e-mail está em um formato que não consideramos válido. Ex: atendimento@vulturedog.com)" },
                    uniqueness: { case_sensitive: false, message: "#{EMAIL} (já existe esse e-mail cadastrado, você usa algum outro que poderia cadastrar?)" }, if: :step1?
  
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  PASSWORD = "Senha"
  PASSWORD_CONFIRMATION = "#{PASSWORD}: confirmação"
  PASSWORD_MIN_CHARS = 6
  if(:step1?)
    has_secure_password
  end
  validates :password, length: { minimum: PASSWORD_MIN_CHARS, message: "#{PASSWORD} (senha está curta, a senha precisa ter no mínimo #{PASSWORD_MIN_CHARS} digitos)" }, if: :step1?

  has_many :ideas, dependent: :destroy

  CPF = "CPF"  
  validates :cpf, presence: { message: "#{CPF} (CPF está em branco)" }, if: :step2?

  LOCAL_STRING = "Localização"
  ADDRESS = "Endereço"
  validates :address, presence: { message: "#{ADDRESS} (endereço está em branco)" }, if: :step2?

  ADDRESS_NUMBER = "número"
  validates :address_num, presence: { message: "#{ADDRESS_NUMBER} (número está em branco)" }, if: :step2?

  ADDRESS_NEIGHBORHOOD = "Bairro"
  validates :district, presence: { message: "#{ADDRESS_NEIGHBORHOOD} (bairro está em branco)" }, if: :step2?

  ADDRESS_CITY = "Cidade"
  validates :city, presence: { message: "#{ADDRESS_CITY} (cidade está em branco)" }, if: :step2?

  ADDRESS_STATE = "Estado"
  validates :region, presence: { message: "#{ADDRESS_STATE} (estado está em branco)" }, if: :step2?

  ADDRESS_COUNTRY = "País"
  validates :country, presence: { message: "#{ADDRESS_COUNTRY} (país está em branco)" }, if: :step2?

  ADDRESS_CEP = "CEP"
  validates :cep, presence: { message: "#{ADDRESS_CEP} (CEP está em branco)" }, if: :step2?

  ADDRESS_PHONE = "Telefone fixo"
  validates :phone, presence: { message: "#{ADDRESS_PHONE} (telefone fixo está em branco)" }, if: :step2?

  BIRTH_DATE = "Data de nascimento"
  ADDRESS_COMPLEMENT = "complemento"
  CELLPHONE = "Celular"
  NOTIFICATIONS_AND_UPDATES = "Quero receber novidades via email"
  FACEBOOK_ASSOCIATION = "Gostaria de associar sua conta do Facebook com sua conta do Comunidéia?"
  GOOGLE_PLUS_ASSOCIATION = "Gostaria de associar sua conta do Google+ com sua conta do Comunidéia?"
  SIGNUP_STRING = "CADASTRAR"
  SAVE_STRING = "Salvar"
  ENTER_STRING = "ENTRAR"
  UPDATED_DATA = "Dados atualizados."
  BASIC_DATA = "Dados básicos"
  CONTACT_STRING = "Contato"
  COUNTRY_BRA = "BRA"

  BRA_STATES_LIST = [

    [User::ADDRESS_STATE+':', ''],
    ['Acre', 'AC'],
    ['Alagoas', 'AL'],
    ['Amapá', 'AP'],
    ['Amazonas', 'AM'],
    ['Bahia', 'BA'],
    ['Ceará', 'CE'],
    ['Distrito Federal', 'DF'],
    ['Espírito Santo', 'ES'],
    ['Goiás', 'GO'],

    ['Maranhão', 'MA'],
    ['Mato Grosso', 'MT'],
    ['Mato Grosso do Sul', 'MS'],
    ['Minas Gerais', 'MG'],
    ['Pará', 'PA'],
    ['Paraíba', 'PB'],
    ['Paraná', 'PR'],
    ['Pernambuco', 'PE'],
    ['Piauí', 'PI'],

    ['Rio de Janeiro', 'RJ'],
    ['Rio Grande do Norte', 'RN'],
    ['Rio Grande do Sul', 'RS'],
    ['Rondônia', 'RO'],
    ['Roraima', 'RR'],
    ['Santa Catarina', 'SC'],
    ['São Paulo', 'SP'],
    ['Sergipe', 'SE'],
    ['Tocantins', 'TO']
  ]


  def feed
    Idea.where("user_id = ?", id)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def auth_provider_association(auth_provider)
    if auth_provider == "google_oauth2"
      self.google_plus_association = true
    elsif auth.provider == "facebook"
      self.facebook_association = true
    end
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
      if !user
        user = User.new(email: auth.info.email, name:auth.info.name, password: ('a'..'z').to_a.shuffle[0,20].join).start
      end

      user.auth_provider_association(auth.provider)
      
      return user, ""
    end

  end

  def User.check_cpf(cpf=nil)
    return false if cpf.nil?
   
    winvalidos = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}
    wvalor = cpf.scan /[0-9]/
    if wvalor.length == 11
      unless winvalidos.member?(wvalor.join)
        wvalor = wvalor.collect{|x| x.to_i}
        wsoma = 10*wvalor[0]+9*wvalor[1]+8*wvalor[2]+7*wvalor[3]+6*wvalor[4]+5*wvalor[5]+4*wvalor[6]+3*wvalor[7]+2*wvalor[8]
        wsoma = wsoma - (11 * (wsoma/11))
        wresult1 = (wsoma == 0 or wsoma == 1) ? 0 : 11 - wsoma
        if wresult1 == wvalor[9]
          wsoma = wvalor[0]*11+wvalor[1]*10+wvalor[2]*9+wvalor[3]*8+wvalor[4]*7+wvalor[5]*6+wvalor[6]*5+wvalor[7]*4+wvalor[8]*3+wvalor[9]*2
          wsoma = wsoma - (11 * (wsoma/11))
          wresult2 = (wsoma == 0 or wsoma == 1) ? 0 : 11 - wsoma
          return true if wresult2 == wvalor[10] # CPF validado
        end
      end
    end
    return false # CPF invalidado
  end

  # start method must be included on models that includes MultiStepModels
  # start method must be called after new method for steps works
  def start
    self.current_step = 0
    self
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    # total_steps method must be included on models that includes MultiStepModels
    def total_steps
      2
    end

    def valid_steps_1_2?
      self.step1? || self.step2?
    end

    def valid_CPF
      if !self.cpf.blank? && !User.check_cpf(self.cpf.to_s)
        errors.add(:cpf, "#{CPF} (O CPF digitado não é válido)")
      end
    end
      
end
