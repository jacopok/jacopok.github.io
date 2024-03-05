module Jekyll
  module CustomFontFilter
    def custom_font(input)
      # Convert Markdown to HTML
      html_content = markdownify(input)
      
      # Wrap each paragraph in the HTML content with custom font styling
      html_content.gsub(/<p>(.*?)<\/p>/m) do |match|
        "<p><span class='schoolbell-regular'>#{$1}</span></p>"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomFontFilter)