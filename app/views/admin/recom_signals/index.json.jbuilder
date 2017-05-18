json.array! @recom_signals do |s|
  json.(s, :datetime, :signal_type)
  json.papers s.signal_papers do |p|
    json.price p.price
    json.name p.paper.name
  end
end
