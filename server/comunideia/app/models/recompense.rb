class Recompense < ActiveRecord::Base
  belongs_to :idea

  default_scope -> { order('financial_value ASC') }
  validates :title, presence: true#, length: { maximum: 80 }#30 }
  #validates :idea_id, presence: true
  validates :quantity, presence: true
  validates :financial_value, presence: true
  validates :summary, presence: true
  validates :date_delivery, presence: true
  
  has_many :investments, dependent: :destroy

end
