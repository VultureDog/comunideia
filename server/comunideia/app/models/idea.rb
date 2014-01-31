class Idea < ActiveRecord::Base

  MAX_RECOMPENSES = 5

  belongs_to :user
  default_scope -> { order('created_at DESC') }

  NAME = "Nome da ideia"
  NAME_MAX_CHARS = 80
  validates :name, presence: { message: "#{NAME} (nome esta em branco, colocar um nome atrativo na ideia pode ser uma boa ideia! Ex: Comunideia)" }, length: { maximum: NAME_MAX_CHARS, message: "#{NAME} (nome esta muito longo, uma boa ideia consegue chamar a atencao com poucas palavras. Maximo de #{NAME_MAX_CHARS} caracteres)" }
  validates :user_id, presence: true

  SUMMARY = "Resumo"
  SUMMARY_MAX_CHARS = 140
  validates :summary, presence: { message: "#{SUMMARY} (resumo esta em branco.)" }, length: { maximum: SUMMARY_MAX_CHARS, message: "#{SUMMARY} (resumo esta muito longo, um pequeno paragrafo consegue transmitir o importante sobre sua ideia. Maximo de #{SUMMARY_MAX_CHARS} caracteres)" }

  PLACE = "Local"
  PLACE_MAX_CHARS = 60
  validates :local, presence: { message: "#{PLACE} (local esta em branco, o lugar onde sua ideia acontece pode ser muito relevante para uma pessoa escolher investir no projeto.)" } , length: { maximum: PLACE_MAX_CHARS, message: "#{PLACE} (o local esta muito longo. Maximo de #{PLACE_MAX_CHARS} caracteres)" }
  
  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} (valor financeiro esta em branco.)" }

  THUMBNAIL_IMG = "Link da imagem do cartao"
  validates :img_card, presence: { message: "#{THUMBNAIL_IMG} (link da imagem do cartao esta em branco.)" }

  IDEA_CONTENT = "Descricao da ideia"
  validates :idea_content, presence: { message: "#{IDEA_CONTENT} (descricao da ideia esta em branco.)" }

  RISKS_AND_CHALLENGES = "Riscos e desafios"
  validates :risks_challenges, presence: { message: "#{RISKS_AND_CHALLENGES} (os riscos e desafios foram deixados em branco.)" }

  DATE_START = "Data de inicio"
  validates :date_start, presence: { message: "#{DATE_START} (a data de inicio nao esta definida.)" }

  DATE_END = "Data de termino"
  validates :date_end, presence: { message: "#{DATE_END} (a data de termino nao esta definida.)" }

  CREATE_IDEA_STRING = "Criar projeto para a ideia"
  IDEA_STRING = "ideia"

  #validates :recompenses, presence: true

  has_many :recompenses, dependent: :destroy
  accepts_nested_attributes_for :recompenses, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

  def createEmptyRecompense
    
    recompenses.new(title:"Investimento altruista.", summary:"Quero ver o projeto realizado e nao e necessario receber para incentivar!", quantity:-1, financial_value:1, date_delivery:Date.today)

  end

end
