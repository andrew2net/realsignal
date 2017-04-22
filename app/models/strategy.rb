class Strategy < ApplicationRecord
  belongs_to :portfolio_strategy, inverse_of: :strategies
  belongs_to :tool, inverse_of: :strategies
  has_many :recom_signals, inverse_of: :strategy
end
