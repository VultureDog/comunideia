require 'active_model'
#srequire 'active_record'

class User < Couchbase::Model
  
  include ActiveModel::Validations
# include ActiveRecord::Validations

  alias :super_save :save
  alias :super_initialize :initialize

  attribute :cpf
  attribute :name
  attribute :email
  attribute :password
  attribute :remember_token

  attr_reader   :errors

  validates :cpf,  presence: true, length: { maximum: 50 }#, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }#,
#                    uniqueness: { case_sensitive: false }

#  has_secure_password
  validates :password, length: { minimum: 6 }

	define_model_callbacks :create
  before_create :create_remember_token

  def initialize
    @errors = ActiveModel::Errors.new(self)
    super_initialize
  end

  def initialize(params = {})
    @errors = ActiveModel::Errors.new(self)
    super_initialize(params)
  end

  def custom_validate?
    if self.cpf.blank?
      errors.add(:cpf_blank, "CPF nao esta preenchido.")
    elsif User.find_by_id(self.cpf)
      errors.add(:cpf_signed_up, "CPF ja cadastrado, usuario ja existe.")
    end

    if self.email.blank?
      errors.add(:email_blank, "E-mail nao esta preenchido.")
    end

    if self.password.blank?
      errors.add(:password_blank, "Senha nao esta preenchida.")
    end

    if errors.count > 0
    	return false
    end
    return true
  end

  def save
    if custom_validate?
      self.id = self.cpf
      self.email = self.email.downcase
      super_save
    end
  end

  def authenticate(password_received)
    password_received == self.password
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