class SiteHelpers < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
  end

  helpers do

    def normalize_url(dirty_URL)
      r = url_for Middleman::Util.normalize_path(dirty_URL)
      r.sub(/\/$/, '')
    end

    def pretty_date(sometime)
      return unless sometime

      sometime = Time.parse(sometime) if sometime.class == String

      format = "%A %e %B"
      format << " %Y" unless sometime.year == Time.now.year

      sometime.to_time.strftime(format) rescue ""
    end

    # Use the title from frontmatter metadata,
    # or peek into the page to find the H1,
    # or fallback to a filename-based-title
    def discover_title(page = current_page)
      page.data.title || page.render({layout: false}).match(/<h1>(.*?)<\/h1>/) do |m|
        m ? m[1] : page.url.split(/\//).last.titleize
      end
    end

    def markdown_to_html content
      Tilt['markdown'].new { content.strip }.render if content
    end

    def word_unwrap content
      content.to_s.gsub(/\n\n/, '!ಠ_ಠ!').gsub(/\n/, ' ').squeeze(' ').gsub(/!ಠ_ಠ!/, "\n\n")
    end

  end
end

::Middleman::Extensions.register(:site_helpers, SiteHelpers)
