# encoding: UTF-8
class Investment < ActiveRecord::Base
  attr_accessor :payment_type

  attr_accessor :expiration_date_month, :expiration_date_year
  attr_accessor :birthday_day, :birthday_month, :birthday_year
  attr_accessor :card_number, :security_code, :owner_name, :owner_phone, :owner_cpf

  PAYMENT_METHOD_CREDIT_CARD = 'credit_card'
  PAYMENT_METHOD_BANK_DEBIT = 'bank_debit'
  PAYMENT_METHOD_PAYMENT_SLIP = 'payment_slip'

  belongs_to :recompense
  default_scope -> { order('created_at DESC') }
  validates :recompense_id, presence: true
  validates :user_id, presence: true

  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} (valor financeiro está em branco.)" }

  INVESTMENT_UNDERSCORE = "_"
  INVESTMENT_VALUE_STRING = "Qual é o valor do seu investimento?"
  INVEST_STRING = "Investir"
  INVESTMENT_STRING = "investimento"
  INVESTMENT_en_STRING = "investiment"
  INVESTMENT_PENDING = 0
  INVESTMENT_NOT_PENDING = 10

end
