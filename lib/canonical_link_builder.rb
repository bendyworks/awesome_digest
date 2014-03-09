require 'htmlentities'

class CanonicalLinkBuilder
  class << self
    def build_full_link(link_elem)
      href = canonical_href_for_link(link_elem)
      link_text = encode_link_text(link_elem)

      "<a href=\"#{href}\">#{link_text}</a>"
    end

    def canonical_href_for_link(link_elem)
      link_target = link_elem["href"]

      canonicalize_link(link_target)
    end

    def encode_link_text(link_elem)
      raw_title = link_elem.text

      encode_title(raw_title)
    end

    def encode_title(title)
      HTMLEntities.new.encode(title, :named)
    end

    def canonicalize_link(link)
      if link =~ /^https?:/
        return link
      end
      "#{HN_URL}/#{link}"
    end
  end
end
