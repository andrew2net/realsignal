class SignalPaper < ApplicationRecord
  belongs_to :recom_signal, inverse_of: :signal_papers
  belongs_to :paper, inverse_of: :signal_papers
end
