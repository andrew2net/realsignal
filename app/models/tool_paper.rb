class ToolPaper < ApplicationRecord
  belongs_to :tool, inverse_of: :tool_papers
  belongs_to :paper, inverse_of: :tool_papers
end
