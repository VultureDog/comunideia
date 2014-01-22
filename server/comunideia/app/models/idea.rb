class Idea < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :name, presence: true, length: { maximum: 80 }
  validates :user_id, presence: true
  validates :summary, presence: true, length: { maximum: 140 }
  validates :local, presence: true, length: { maximum: 60 }
  validates :financial_value, presence: true
  validates :img_card, presence: true
  validates :idea_content, presence: true
  validates :risks_challenges, presence: true
  #validates :recompenses, presence: true

  has_many :recompenses, dependent: :destroy
  accepts_nested_attributes_for :recompenses, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  has_many :donations, dependent: :destroy

end