class PortfolioStrategy < ApplicationRecord
  has_many :strategies, inverse_of: :portfolio_strategy
end
