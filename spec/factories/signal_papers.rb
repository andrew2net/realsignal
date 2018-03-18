FactoryBot.define do
  factory :signal_paper do
    recom_signal
    paper
    price { 1 + rand(1.5) }
    initialize_with { SignalPaper.find_or_initialize_by(recom_signal: recom_signal, paper: paper) }
  end
end
