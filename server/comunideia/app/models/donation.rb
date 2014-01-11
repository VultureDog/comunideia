class Donation < ActiveRecord::Base
  belongs_to :idea
  default_scope -> { order('created_at DESC') }
  validates :idea_id, presence: true
  validates :user_id, presence: true
  validates :financial_value, presence: true
  validates :date, presence: true
end
