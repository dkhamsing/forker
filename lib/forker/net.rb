# Networking
module Forker
  require 'net/http'
  require 'uri'

  class << self
    def net_content_for_url(url)
      Net::HTTP.get(URI.parse(url))
    end

    def net_find_links(content)
      links_found = URI.extract(content, /http()s?/)

      links_to_check =
        links_found.reject { |x| x.length < 9 }
        .map { |x| x.gsub(/\).*/, '').gsub(/'.*/, '').gsub(/,.*/, '').gsub('/:', '/') }
      # ) for markdown
      # ' found on https://fastlane.tools/
      # , for link followed by comma
      # : found on ircanywhere/ircanywhere

      [links_to_check, links_found]
    end
  end # class
end
