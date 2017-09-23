module Application::CommonHelper
  def flash_messages(flash)
    messages = flash.map do |name, msg|
      cls = case name
      when "alert"
        "bg-danger"
      when "notice"
        "bg-success"
      else
        "bg-warning"
      end
      content_tag :p, msg, class: "flash-message #{cls}"
    end
    messages.join("").html_safe
  end
end
