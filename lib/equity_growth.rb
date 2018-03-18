module EquityGrowth

  class << self
    def calc_data(strategy)
      tool_papers = strategy.tool.tool_papers
        .reduce({}) {|h,t| h.merge({t.paper_id => t.volume})}

      prev_siganl = nil
      profits = []
      summ = 0

      strategy.recom_signals
      .includes(signal_papers: :paper).each do |signal|

        # When first itteration or next siganl after deal closed.
        if prev_siganl.nil? && signal.signal_type.match(/Open (Buy|Sell)$/) ||
          prev_siganl.signal_type.match(/Close (Buy|Sell)$/)
          prev_siganl = signal
        # When it's a second signal of a deal.
        elsif prev_siganl.signal_type.match(/Open Buy$/) and
          signal.signal_type.match(/^Close Buy/) or
          (prev_siganl.signal_type.match(/Open Sell$/) and
          signal.signal_type.match(/^Close Sell/))

          cp_open = complex_price(signal: prev_siganl, tool_papers: tool_papers)
          cp_close = complex_price(signal: signal, tool_papers: tool_papers)
          funds = complex_price(signal: prev_siganl, tool_papers: tool_papers, volume_mod: true)
          next if funds == 0
          profit = (cp_close - cp_open) / funds * strategy.leverage
          profit *= -1 if signal.signal_type.match(/^Close Sell/)
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

        tp_vol = tool_papers[signal_paper.paper_id]
        tp_vol = tp_vol.abs if volume_mod

        sum += signal_paper.price * tp_vol * signal_paper.paper.tick_cost / signal_paper.paper.tick_size
      end
    end
  end
end
