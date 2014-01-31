# encoding: UTF-8
class Idea < ActiveRecord::Base

  MAX_RECOMPENSES = 5

  belongs_to :user
  default_scope -> { order('created_at DESC') }

  NAME = "Nome da idéia"
  NAME_MAX_CHARS = 80
  validates :name, presence: { message: "#{NAME} (nome está em branco, colocar um nome atrativo na idéia pode ser uma boa idéia! Ex: Comunidéia)" }, length: { maximum: NAME_MAX_CHARS, message: "#{NAME} (nome está muito longo, uma boa idéia consegue chamar a atenção com poucas palavras. Máximo de #{NAME_MAX_CHARS} caracteres)" }
  validates :user_id, presence: true

  SUMMARY = "Resumo"
  SUMMARY_MAX_CHARS = 140
  validates :summary, presence: { message: "#{SUMMARY} (resumo está em branco.)" }, length: { maximum: SUMMARY_MAX_CHARS, message: "#{SUMMARY} (resumo está muito longo, um pequeno parágrafo consegue transmitir o importante sobre sua idéia. Máximo de #{SUMMARY_MAX_CHARS} caracteres)" }

  PLACE = "Local"
  PLACE_MAX_CHARS = 60
  validates :local, presence: { message: "#{PLACE} (local está em branco, o lugar onde sua idéia acontece pode ser muito relevante para uma pessoa escolher investir no projeto.)" } , length: { maximum: PLACE_MAX_CHARS, message: "#{PLACE} (o local está muito longo. Máximo de #{PLACE_MAX_CHARS} caracteres)" }
  
  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} (valor financeiro está em branco.)" }

  THUMBNAIL_IMG = "Link da imagem do cartão"
  validates :img_card, presence: { message: "#{THUMBNAIL_IMG} (link da imagem do cartão está em branco.)" }

  IDEA_CONTENT = "Descrição da idéia"
  validates :idea_content, presence: { message: "#{IDEA_CONTENT} (descrição da idéia está em branco.)" }

  RISKS_AND_CHALLENGES = "Riscos e desafios"
  validates :risks_challenges, presence: { message: "#{RISKS_AND_CHALLENGES} (os riscos e desafios foram deixados em branco.)" }

  DATE_START = "Data de início"
  validates :date_start, presence: { message: "#{DATE_START} (a data de início nao está definida.)" }

  DATE_END = "Data de término"
  validates :date_end, presence: { message: "#{DATE_END} (a data de término nao está definida.)" }

  CREATE_IDEA_STRING = "Criar projeto para a idéia"
  IDEA_STRING = "idéia"

  #validates :recompenses, presence: true

  has_many :recompenses, dependent: :destroy
  accepts_nested_attributes_for :recompenses, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

  def createEmptyRecompense
    
    recompenses.new(title:"Investimento altruísta.", summary:"Quero ver o projeto realizado e não é necessário receber para incentivar!", quantity:-1, financial_value:1, date_delivery:Date.today)

  end

end
