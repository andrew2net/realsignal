module EquityGrowth

  class << self
    def calc_data(strategy)
      tool_papers = strategy.tool.tool_papers
        .reduce({}) {|h,t| h.merge({t.paper_id => t.volume})}

      prev_siganl = nil
      # close_buy_types = ['Close Buy', 'Close Buy, Open Sell']
      profits = []
      summ = 0

      strategy.recom_signals # .where.not(signal_type: ['Close Buy', 'Close Sell'])
      .includes(signal_papers: :paper).each do |signal|

        if prev_siganl.nil? or prev_siganl.signal_type.match(/Close (Buy|Sell)$/)
          prev_siganl = signal
        elsif prev_siganl.signal_type.match(/Open Buy$/) and
          signal.signal_type.match(/^Close Buy/) or
          (prev_siganl.signal_type.match(/Open Sell$/) and
          signal.signal_type.match(/^Close Sell/))

          cp_open = complex_price(signal: prev_siganl, tool_papers: tool_papers)
          cp_close = complex_price(signal: signal, tool_papers: tool_papers)
          funds = complex_price(signal: prev_siganl, tool_papers: tool_papers, volume_mod: true)
          profit = (cp_close - cp_open) / funds * strategy.leverage
          summ += profit
          profits << [signal.datetime, summ]

          prev_siganl = signal
        else
          signal.destroy
        end

      end
      profits
    end

    private

    def complex_price(signal:, tool_papers:, volume_mod: false)
      signal.signal_papers.reduce(0) do |sum, signal_paper|

        begin
          tp_vol = tool_papers[signal_paper.paper_id]
          tp_vol = tp_vol.abs if volume_mod

          sum += signal_paper.price * tp_vol * signal_paper.paper.tick_cost / signal_paper.paper.tick_size
        rescue => e
          Rails.logger.debug e.message
          Rails.logger.debug tool_papers.inspect
          Rails.logger.debug signal_paper.paper_id
        end
      end
    end
  end
end
