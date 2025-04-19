module BoardsHelper
  def highlight(content, with:)
    sanitize content.gsub(with, "<span class='bg-secondary/50'>#{with}</span>")
  end
end
