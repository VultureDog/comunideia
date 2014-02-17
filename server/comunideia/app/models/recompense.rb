# encoding: UTF-8
class Recompense < ActiveRecord::Base

  belongs_to :idea
  default_scope -> { order('financial_value ASC') }

  TITLE = "Título"
  TITLE_MAX_CHARS = 30
  validates :title, presence: { message: "#{TITLE} de uma recompensa (título está em branco)" }, length: { maximum: TITLE_MAX_CHARS, message: "#{TITLE} de uma recompensa (titulo está muito longo. Maximo de #{TITLE_MAX_CHARS} caracteres)" }

  #validates :idea_id, presence: true

  QUANTITY = "Quantidade"
  validates :quantity, presence: { message: "#{QUANTITY} de uma recompensa (quantidade de recompensas está em branco)" }

  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} de uma recompensa (valor financeiro da recompensa está em branco.)" }

  SUMMARY = "Resumo"
  SUMMARY_MAX_CHARS = 140
  validates :summary, presence: { message: "#{SUMMARY} de uma recompensa (resumo da recompensa está em branco.)" }, length: { maximum: SUMMARY_MAX_CHARS, message: "#{SUMMARY} de uma recompensa (resumo da recompensa está muito longo. Máximo de #{SUMMARY_MAX_CHARS} caracteres)" }

  DATE_DELIVERY = "Data de início"
  validates :date_delivery, presence: { message: "#{DATE_DELIVERY} de uma recompensa (a data de entrega da recompensa nao está definida.)" }

  RECOMPENSE_ADD = "Adicionar recompensa"
  RECOMPENSE_REMOVE = "remover"
  RECOMPENSE_ID_PREFIX = 999
  
  has_many :investments, dependent: :destroy

end
