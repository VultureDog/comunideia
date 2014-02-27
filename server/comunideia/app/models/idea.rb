# encoding: UTF-8
class Idea < ActiveRecord::Base
  
  include MultiStepModel

  MAX_RECOMPENSES = 5

  belongs_to :user
  default_scope -> { order('created_at DESC') }

  NAME = "Nome da idéia"
  NAME_MAX_CHARS = 80
  validates :name, presence: { message: "#{NAME} (nome está em branco, colocar um nome atrativo na idéia pode ser uma boa idéia! Ex: Comunidéia)" }, length: { maximum: NAME_MAX_CHARS, message: "#{NAME} (nome está muito longo, uma boa idéia consegue chamar a atenção com poucas palavras. Máximo de #{NAME_MAX_CHARS} caracteres)" }
  validates :user_id, presence: true, if: :step1?

  COMUNIDEIA_EM_ACAO    = 1
  COMUNIDEIA_EM_FINANCIAMENTO    = 2

  STATUSES = {
    COMUNIDEIA_EM_ACAO    => 'comunidéia em ação',
    COMUNIDEIA_EM_FINANCIAMENTO    => 'comunidéia em financiamento'
  }

  SUMMARY = "Resumo"
  SUMMARY_MAX_CHARS = 140
  validates :summary, presence: { message: "#{SUMMARY} (resumo está em branco.)" }, length: { maximum: SUMMARY_MAX_CHARS, message: "#{SUMMARY} (resumo está muito longo, um pequeno parágrafo consegue transmitir o importante sobre sua idéia. Máximo de #{SUMMARY_MAX_CHARS} caracteres)" }, if: :step1?

  IDEA_CONTENT = "Descrição da idéia"
  validates :idea_content, presence: { message: "#{IDEA_CONTENT} (descrição da idéia está em branco.)" }, if: :step1?

  PLACE = "Local"
  PLACE_MAX_CHARS = 60
  validates :local, presence: { message: "#{PLACE} (local está em branco, o lugar onde sua idéia acontece pode ser muito relevante para uma pessoa escolher investir no projeto.)" } , length: { maximum: PLACE_MAX_CHARS, message: "#{PLACE} (o local está muito longo. Máximo de #{PLACE_MAX_CHARS} caracteres)" }, if: :valid_steps_2_3?

  FINANCIAL_VALUE = "Valor financeiro"
  validates :financial_value, presence: { message: "#{FINANCIAL_VALUE} (valor financeiro está em branco.)" }, if: :step2?

  THUMBNAIL_IMG = "Link da imagem do cartão"
  validates :img_card, presence: { message: "#{THUMBNAIL_IMG} (link da imagem do cartão está em branco.)" }, if: :step2?

  RISKS_AND_CHALLENGES = "Riscos e desafios"
  validates :risks_challenges, presence: { message: "#{RISKS_AND_CHALLENGES} (os riscos e desafios foram deixados em branco.)" }, if: :step2?

  DATE_START = "Data de início"
  validates :date_start, presence: { message: "#{DATE_START} (a data de início nao está definida.)" }, if: :step2?

  DATE_END = "Data de término"
  validates :date_end, presence: { message: "#{DATE_END} (a data de término nao está definida.)" }, if: :step2?

  CONSULTING_PROJECT_STRING = "Quero uma consultoria geral, quero ajuda para colocar minha idéia em prática"
  CONSULTING_CREATIVITY_STRING = "Quero ajuda criativa, um nome matador, logotipo e coisas visualmente lindas!"
  CONSULTING_FINANCIAL_STRUCTURE_STRING = "Quero ajuda para estruturar o pedido de financimento coletivo para minha idéia."
  CONSULTING_SPECIFIC_STRING = "Quero uma ajuda específica que é:"

  SAVE_IDEA_STRING = "Salvar projeto para a idéia"
  IDEA_STRING = "idéia"

  has_many :recompenses, dependent: :destroy
  accepts_nested_attributes_for :recompenses, :allow_destroy => true

  # helper method for the views
  def status_name
    STATUSES[status]
  end

  def createEmptyRecompense
    
    recompenses.build(title:"Investimento altruísta.", summary:"Quero ver o projeto realizado e não é necessário receber para incentivar!", quantity:-1, financial_value:1, date_delivery:Date.today).start

  end

  # start method must be included on models that includes MultiStepModels
  # start method must be called after new method for steps works
  def start
    self.current_step = 0
    self
  end

  def valid_and_set_steps
    save = false
    if self.current_step_valid?
      save = true
    end
    save
  end

  def step_forward
    # step_forward
    if self.status == Idea::COMUNIDEIA_EM_FINANCIAMENTO
      self.current_step = 1
    elsif self.status == Idea::COMUNIDEIA_EM_ACAO
      self.current_step = 2
    end
  end

  # total_steps method must be included on models that includes MultiStepModels
  def total_steps
    3
  end

  def valid_steps_2_3?
    self.step2? || self.step3?
  end
  
end
