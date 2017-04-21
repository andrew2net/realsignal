class Paper < ApplicationRecord
  has_many :tool_papers, inverse_of: :paper
  has_many :signal_papers, inverse_of: :paper
end
