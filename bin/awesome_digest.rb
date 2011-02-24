#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'pony'
require 'ruby-debug'

# lib/* requires
require 'array_ext'
# require 'awesome_digest'
# require 'credentials'

url = "#{HN_URL}/active"
doc = Nokogiri::HTML(open(url))

zipped_elements = doc.css("tr td.title[3]").zip(doc.css("tr td.subtext"))

scraped_posts = []

subtext_regex = /\A(?<points>\d+ points?)\Wby\W(?<poster>\w+)\W(?<num_of>\d+)\W(?<time_type>minutes?|hours?|days?|weeks?|months?|years?)\Wago\W+\|\W(?<comments>\d+ comments?|discuss)/

zipped_elements.each do |e|
  m = subtext_regex.match(e.second.text)
  if m[:time_type] =~ /minutes?|hours?/
    post_map = {}
    post_map[:full_link]   = e.first.xpath("a").to_html
    post_map[:text_link]   = e.first.at_xpath("a[@href]").values.first
    post_map[:time_ago]    = "#{m[:num_of]} #{m[:time_type]} ago"
    post_map[:points]      = m[:points]
    post_map[:comments]    = m[:comments] # if m[:comments] != "discuss"
    post_map[:poster]      = m[:poster]
    scraped_posts << post_map
  end
end

# Extract to credentials file.
HN_URL            = ''
SENDGRID_SERVER   = 'smtp.sendgrid.com'
SENDGRID_USERNAME = ''
SENDGRID_PASSWORD = ''
EMAIL_TO          = 'others@example.com'
EMAIL_FROM        = 'me@example.com'
SUBJECT_PREFIX    = 'My Digest Email' # " - 02/02/2042"
SERVER_DOMAIN     = 'localhost.localdomain'
SERVER_PORT       = '25'
SERVER_AUTH       = :plain

li_links    = scraped_posts.map {|p| "<li>#{p[:full_link]}<br />#{p[:text_link]}<br />by #{p[:poster]}, #{p[:points]}</li>"}.join("<br />")
text_digest = scraped_posts.map {|p| p[:text_link] + '\r\n'}
html_digest = "<html><body><h2>The Daily Awesome</h2><ul>#{li_links}</ul></body></html>"

# Extract to sendgrid_setup
server_settings = {
  address: SENDGRID_SERVER,
  port: SERVER_PORT,
  user_name: SENDGRID_USERNAME,
  password: SENDGRID_PASSWORD,
  authentication: SERVER_AUTH,
  domain: SERVER_DOMAIN}

Pony.mail(to: EMAIL_TO,
          from: EMAIL_FROM,
          via: :smtp,
          via_options: server_settings,
          subject: "#{SUBJECT_PREFIX} - #{Time.now.strftime('%m-%d-%Y')}",
          html_body: html_digest,
          body: text_digest)
