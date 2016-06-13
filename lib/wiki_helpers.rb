# Various useful functions for Middleman-based sites
class WikiHelpers < Middleman::Extension
  def initialize(app, options_hash = {}, &block)
    super
  end

  helpers do
    def load_redirects
      return $helper_wiki_redirects if $helper_wiki_redirects

      slashes = /^\/|\/$/

      redirects = File.readlines "#{root}/#{source}/redirects.yaml"

      $helper_wiki_redirects ||= redirects.map do |line|
        splits = line.split(': ')

        {
          from: splits.first.gsub(slashes, '').strip,
          to: splits.last.gsub(slashes, '').strip
        }
      end.compact
    end

    def find_wiki_page(searchkey)
      searchkey.sub!(/^ /, '#') # Handle a weird wiki-ism (space for hashes?)

      # Regular expression to grab the extra bits at the end of a URL
      extra = /[#\?].*/

      # The extra stuff at the end of a URL,
      # reformatted to use new hashes
      url_extra = searchkey
                  .match(extra).to_s
                  .tr('_', '-').tr(' ', '-')
                  .downcase.squeeze('-')

      # The URL fragment, cleaned up and modified
      url_fixed = searchkey
                  .sub(extra, '').tr('_', ' ')
                  .gsub(/^\/|\/$/, '')
                  .downcase

      # Processed redirects, filtered to requested page
      match_redir = load_redirects.map do |redir|
        next if url_fixed.empty?

        exact_match = redir[:from].downcase == url_fixed
        page_match = redir[:from].downcase.end_with?("/#{url_fixed}")

        redir[:to].downcase.tr('_', ' ') if exact_match || page_match
      end.compact

      result = nil

      # Find the matching page throughout the iste
      sitemap.resources.each do |resource|
        next unless resource.data.wiki_title

        wiki_title = resource.data.wiki_title.to_s.downcase.strip

        # Check direct matches
        matches ||= wiki_title == url_fixed

        # Handle redirects
        matches ||= match_redir.include? wiki_title

        # Return true if it matches, else it's false
        if matches
          result = resource.url + url_extra
          break
        end
      end

      # Return the URL with the extra hash
      result
    end
  end
end

::Middleman::Extensions.register(:wiki_helpers, WikiHelpers)
