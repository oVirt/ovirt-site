class SiteHelpers < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
  end

  helpers do

    def normalize_url(dirty_URL)
      r = url_for Middleman::Util.normalize_path(dirty_URL)
      r.sub(/\/$/, '')
    end

    # FIXME: This is a WIP; it's not working though...
    def pretty_date(sometime)
      Date.strptime(sometime, "%Y-%m-%d") if sometime.is_a?(String)
    end

    # Use the title from frontmatter metadata,
    # or peek into the page to find the H1,
    # or fallback to a filename-based-title
    def discover_title(page = current_page)
      page.data.title || page.render({layout: false}).match(/<h1>(.*?)<\/h1>/) do |m|
        m ? m[1] : page.url.split(/\//).last.titleize
      end
    end

  end
end

::Middleman::Extensions.register(:site_helpers, SiteHelpers)
