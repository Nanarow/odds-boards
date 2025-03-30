module IconsHelper
  def render_icon(filename, **options)
    file_path = Rails.root.join("app/assets/icons/#{filename}.svg")
    return "Icon not found." unless file_path.exist?

    svg_content = file_path.read
    svg_content.sub!("<svg", "<svg #{tag.attributes(options)} ")
    raw(svg_content)
  end
end
