class BlogHelpers < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    require 'oj'
    require 'digest/md5'

    super
  end

  helpers do

    def normalize_url(dirty_URL)
      r = url_for Middleman::Util.normalize_path(dirty_URL)
      r.sub(/\/$/, '')
    end

    def pretty_date(sometime, length = "long")
      return unless sometime

      sometime = Time.parse(sometime) if sometime.class == String

      format = length == "short" ? "%a %e %b" : "%A %e %B"
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

    def word_unwrap content
      content.to_s.gsub(/\n\n/, '!ಠ_ಠ!').gsub(/\n/, ' ').squeeze(' ').gsub(/!ಠ_ಠ!/, "\n\n")
    end

    def markdown_to_html content
      Tilt['markdown'].new(config[:markdown]) { content.strip }.render if content
    end

    def markdown_to_plaintext content
      word_unwrap Nokogiri::HTML(markdown_to_html(content)).text.strip
    end

    def demote_headings content
      h_add = case content
        when /<h1>/
          2
        when /<h2>/
          1
        else
          nil
      end

      if h_add
        content.to_str.gsub(/<(\/?)h([1-6])>/) {|m| "<#{$1}h#{$2.to_i + h_add}>"}.html_safe
      else
        content
      end
    end

    def author_name nickname
      data.authors[nickname] ? data.authors[nickname].name : nickname
    end

    def author_link nickname, text = author_name(nickname)
      link_to text, "/blog/author/#{nickname.parameterize.downcase}/"
    end

    def author_card nickname
      return @author_card[nickname] if @author_card

      @author_card ||= {}

      author = data.authors[nickname]

      @author_card[nickname] = if author && author['description']
        author['description']
      end

      author_card nickname
    end

    def author_gravatar nickname
      return @author_gravatar[nickname] if @author_gravatar && defined? @author_gravatar[nickname]

      @author_gravatar ||= {}

      author = data.authors[nickname]

      return unless (author['gravatar'] || author['email'])

      g_hash = author['gravatar'] || Digest::MD5.hexdigest(author['email'])
      g_json = open("http://gravatar.com/#{g_hash}.json").read rescue nil

      @author_gravatar[nickname] = if author && g_json
        Oj.load g_json
      end

      author_gravatar nickname
    end

    def author_photo nickname
      profile = author_gravatar nickname

      image_tag profile['entry'][0]['thumbnailUrl'] if profile
    end

  end
end

::Middleman::Extensions.register(:blog_helpers, BlogHelpers)
