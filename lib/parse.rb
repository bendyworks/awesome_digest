def parse_feed(doc)
  zipped_elements = doc.css("tr td.title[3]").zip(doc.css("tr td.subtext"))

  scraped_posts = []

  # Parses the subtext under the news article for:
  # "1 point(s)", "username", "5", "minute(s), hours, etc.",
  # "1 comment(s) (or "discuss" if there are no comments)"
  subtext_regex = /\A(?<points>\d+ points?)\Wby\W(?<poster>\w+)\W(?<num_of>\d+)\W(?<time_type>minutes?|hours?|days?|weeks?|months?|years?)\Wago\W+\|\W(?<comments>\d+ comments?|discuss)/

  zipped_elements.each do |e|
    m = subtext_regex.match(e.second.text)

    if m[:time_type] =~ /minutes?|hours?/
      post_map = {}
      post_map[:full_link]      = e.first.xpath("a").to_html
      post_map[:text_link]      = e.first.at_xpath("a[@href]").values.first
      post_map[:domain]         = e.first.children.children.last.text
      post_map[:time_ago]       = "#{m[:num_of]} #{m[:time_type]} ago"
      post_map[:points]         = m[:points]
      post_map[:comments_link]  = "#{HN_URL}/#{e[1].children[-1].attributes['href'].value}"
      post_map[:comments]       = m[:comments]
      post_map[:poster]         = m[:poster]
      scraped_posts << post_map
    end
  end

  if scraped_posts.present?
    li_links = scraped_posts.each_with_index.map { |post, i|
      Haml::Engine.new(File.read('views/link.haml')).render(Object.new, {:post => post, :i => i})
      #"<li>#{p[:full_link]}<br />#{p[:text_link]}<br />by #{p[:poster]}, #{p[:points]}</li>"
    }.join

    text_digest = scraped_posts.map {|p| p[:text_link] + '\r\n'}

    html_digest = Haml::Engine.new(File.read('views/email.haml')).render(Object.new, {:li_links => li_links})
                  # "<html><body><h2>#{EMAIL_HEADER}</h2><ul>#{li_links}</ul></body></html>"

    return { text_digest: text_digest,
             html_digest: html_digest }
  elsif SEND_EMPTY
    return { text_digest: EMPTY_MESSAGE,
             html_digest: Haml::Engine.new(File.read('views/email.haml')).render(Object.new, {:li_links => EMPTY_MESSAGE }) }
  else
    puts "No new posts to send!"
    Kernel.exit
  end
end
