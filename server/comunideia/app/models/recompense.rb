class Recompense < ActiveRecord::Base

  belongs_to :idea
  default_scope -> { order('financial_value ASC') }

  TITLE = "Titulo"
  TITLE_MAX_CHARS = 30
  validates :title, presence: { message: "#{TITLE} (titulo esta em branco)" }#, length: { maximum: 80, message: "#{TITLE} (titulo esta muito longo. Maximo de #{TITLE_MAX_CHARS} caracteres)" }

  #validates :idea_id, presence: true

  QUANTITY = "Quantidade"
  validates :quantity, presence: { message: "#{QUANTITY} (quantidade de recompensas esta em branco)" }

  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} (valor financeiro da recompensa esta em branco.)" }

  SUMMARY = "Resumo"
  SUMMARY_MAX_CHARS = 140
  validates :summary, presence: { message: "#{SUMMARY} (resumo da recompensa esta em branco.)" }, length: { maximum: SUMMARY_MAX_CHARS, message: "#{SUMMARY} (resumo da recompensa esta muito longo. Maximo de #{SUMMARY_MAX_CHARS} caracteres)" }

  DATE_DELIVERY = "Data de inicio"
  validates :date_delivery, presence: { message: "#{DATE_DELIVERY} (a data de entrega da recompensa nao esta definida.)" }

  RECOMPENSE_ADD = "Adicionar recompensa"
  RECOMPENSE_REMOVE = "remover"
  RECOMPENSE_ID_PREFIX = 999
  
  has_many :investments, dependent: :destroy

end
