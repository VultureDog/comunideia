class Investment < ActiveRecord::Base
  belongs_to :recompense
  default_scope -> { order('created_at DESC') }
  validates :recompense_id, presence: true
  validates :user_id, presence: true
  validates :financial_value, presence: true
end
