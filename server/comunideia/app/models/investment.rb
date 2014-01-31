# encoding: UTF-8
class Investment < ActiveRecord::Base
  belongs_to :recompense
  default_scope -> { order('created_at DESC') }
  validates :recompense_id, presence: true
  validates :user_id, presence: true

  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} (valor financeiro está em branco.)" }

  INVESTMENT_VALUE_STRING = "Qual é o valor do seu investimento?"
  INVEST_STRING = "Investir"
  INVESTMENT_STRING = "investimento"

end
