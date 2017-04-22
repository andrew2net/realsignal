class Tool < ApplicationRecord
  has_many :strategies, inverse_of: :tool
  has_many :tool_papers, inverse_of: :tool

  def self.all_with_papers
    self.includes(:tool_papers).map do |t|
      papers = t.tool_papers.map do |p|
        { id: p.id, paper_id: p.paper_id, volume: p.volume }
      end
      { id: t.id, name: t.name, papers: papers }
    end
  end
end
