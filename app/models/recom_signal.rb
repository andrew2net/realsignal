class RecomSignal < ApplicationRecord
  belongs_to :strategy, inverse_of: :recom_signals
  has_many :signal_papers, inverse_of: :recom_signal
  enum signal_type: [
    'Open Buy',
    'Open Sell',
    'Close Buy',
    'Close Sell',
    'Close Buy, Open Sell',
    'Close Sell, Open Buy'
  ]
end
