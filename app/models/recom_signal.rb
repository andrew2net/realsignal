class RecomSignal < ApplicationRecord
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

  INVERSE_SIGNALS = {
    'Open Buy' => 'Open Sell',
    'Open Sell' => 'Open Buy',
    'Close Buy, Open Sell' => 'Close Sell, Open Buy',
    'Close Sell, Open Buy' => 'Close Buy, Open Sell',
    'Close Buy' => 'Close Sell',
    'Close Sell' => 'Close Buy'
  }

  def notify_users
    # Don't notify if signal oldest than 12 hours
    time_diff = ((DateTime.now.to_i - datetime.to_i) / 1.hour).round
    return if time_diff > 12 || !is_last?

    # Make message
    spapers = signal_papers.map do |sp|
      tool_paper = strategy.tool.tool_papers.find_by_paper_id sp.paper_id
      sb = if tool_paper.volume < 0
        INVERSE_SIGNALS[signal_type]
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
    self.class.where(strategy_id: strategy_id).where.not(id: id).maximum(:datetime) < datetime
  end
end
