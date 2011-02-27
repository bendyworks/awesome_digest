class AwesomeDigest

  def initialize
    doc = Nokogiri::HTML(open("#{HN_URL}"))

    zipped_elements = doc.css("tr td.title[3]").zip(doc.css("tr td.subtext"))

    scraped_posts = []
    build_scraped_posts(zipped_elements)
  end

  def subtext_regex
    /\A(?<points>\d+ points?)\Wby\W(?<poster>\w+)\W(?<num_of>\d+)\W(?<time_type>minutes?|hours?|days?|weeks?|months?|years?)\Wago\W+\|\W(?<comments>\d+ comments?|discuss)/
  end

  def build_scraped_posts(zipped_elements)
    zipped_elements.each do |e|
      m = subtext_regex.match(e.second.text)
      if m[:time_type] =~ /minutes?|hours?/
        @recent_posts = true

        post_map = {}
        post_map[:full_link]   = e.first.xpath("a").to_html
        post_map[:text_link]   = e.first.at_xpath("a[@href]").values.first
        post_map[:time_ago]    = "#{m[:num_of]} #{m[:time_type]} ago"
        post_map[:points]      = m[:points]
        post_map[:comments]    = m[:comments] # if m[:comments] != "discuss"
        post_map[:poster]      = m[:poster]
        scraped_posts << post_map
      else
        @recent_posts = false
      end
    end
  end


  def build_post_map
  end

  def parse_subtext
  end

  def build_html_content(scraped_posts)
    scraped_posts.map {|p| "<li>#{p[:full_link]}<br />#{p[:text_link]}<br />by #{p[:poster]}, #{p[:points]}</li>"}.join("<br />")
  end

  def wrap_html_content(content)
  end

  def build_text_content
  end

  def fire_email
  end
end
