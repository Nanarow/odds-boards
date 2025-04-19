module BoardsHelper
  def highlight(content, with:)
    if with.present? && !with.blank?
      sanitize content.gsub(with, "<span class='bg-secondary/50'>#{with}</span>")
    else
      content
    end
  end
end
