class RecomSignal < ApplicationRecord
  has_many :signal_papers, inverse_of: :recom_signal
end
