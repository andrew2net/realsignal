class RecomSignal < ApplicationRecord
  class SequenceError < StandardError
  end

  belongs_to :strategy, inverse_of: :recom_signals
  has_many :signal_papers, inverse_of: :recom_signal

  default_scope { order(:datetime) }

  enum signal_type: [
    'Open Buy',
    'Open Sell',
    'Close Buy, Open Sell',
    'Close Sell, Open Buy',
    'Close Buy',
    'Close Sell'
  ]

  SIGNAL_RULES = {
    'Open Buy'             => { inverse: 'Open Sell', next_allowed: ['Close Buy', 'Close Buy, Open Sell'] },
    'Open Sell'            => { inverse: 'Open Buy', next_allowed: ['Close Sell', 'Close Sell, Open Buy'] },
    'Close Buy, Open Sell' => { inverse: 'Close Sell, Open Buy', next_allowed: ['Close Sell', 'Close Sell, Open Buy'] },
    'Close Sell, Open Buy' => { inverse: 'Close Buy, Open Sell', next_allowed: ['Close Buy', 'Close Buy, Open Sell'] },
    'Close Buy'            => { inverse: 'Close Sell', next_allowed: ['Open Buy', 'Open Sell'] },
    'Close Sell'           => { inverse: 'Close Buy', next_allowed: ['Open Buy', 'Open Sell'] }
  }

  def notify_users
    # Don't notify if signal oldest than 12 hours
    time_diff = ((DateTime.now.to_i - datetime.to_i) / 1.hour).round
    return if time_diff > 12 || !is_last?

    # Make message
    spapers = signal_papers.map do |sp|
      tool_paper = strategy.tool.tool_papers.find_by_paper_id sp.paper_id
      sb = if tool_paper.volume < 0
        SIGNAL_RULES[sgnal_type][:inverse]
      else
        signal_type
      end
      "*#{sb}* #{tool_paper.volume.abs} _#{tool_paper.paper.name}_, #{sp.price}"
    end
    text = "#{datetime}\n#{spapers.join("\n")}"

    # Send notifications
    User.joins(subscriptions: :subscription_type).where.not(chat_id: nil)
    .where(subscription_types: { portfolio_strategy_id: strategy.portfolio_strategy.id })
    .where("subscriptions.end_date>=?", DateTime.now).find_each do |user|
      Telegram.bot.send_message chat_id: user.chat_id, text: text, parse_mode: "Markdown"
    end
  end

  # Check if the signal is last for the strategy
  def is_last?
    max_date = self.class.where(strategy_id: strategy_id).where.not(id: id).maximum(:datetime)
    !max_date || max_date < datetime
  end

  def self.create_signal(strategy_id:, signal_type:, time:)
    datetime = DateTime.parse time
    # Find previous signal.
    prev_signal = RecomSignal.where(strategy_id: strategy_id)
      .where('datetime < ?', datetime).order(:datetime).last
    # If previous signal is last then check whether new signal match to rules with previous signal.
    if prev_signal&.is_last? && !signal_type.in?(SIGNAL_RULES[prev_signal.signal_type][:next_allowed])
      raise SequenceError, 'Allowed sequence is broken'
    end

    signal = RecomSignal.find_or_initialize_by strategy_id: strategy_id,
      datetime: datetime
    signal.signal_type = RecomSignal.signal_types[signal_type]
    signal if signal.save
  end
end
