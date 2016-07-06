# Various helpers to enhance Middleman-based blogging
class BlogHelpers < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    require 'oj'
    require 'digest/md5'

    $article_taglist = {}
    $optimized_tags = {}

    super
  end

  helpers do
    def author_name(nick)
      data.authors[nick] ? data.authors[nick].name || nick : nick
    end

    def author_link(nickname, text = author_name(nickname))
      link_to text, "/blog/author/#{nickname.parameterize.downcase}/"
    end

    def author_card(nickname)
      return @author_card[nickname] if @author_card

      @author_card ||= {}
      author = data.authors[nickname]
      twitter_link = '[@\1](https://twitter.com/\1)'

      @author_card[nickname] = if author && author['description']
                                 desc = author['description'].dup
                                 desc.gsub!(/@(\w+)/, twitter_link)
                                 markdown_to_html desc
                               end

      @author_card[nickname]
    end

    def author_gravatar(nickname)
      if @author_gravatar && defined? @author_gravatar[nickname]
        return @author_gravatar[nickname]
      end

      @author_gravatar ||= {}

      author = data.authors[nickname]

      return unless author['gravatar'] || author['email']

      g_hash = author['gravatar'] || Digest::MD5.hexdigest(author['email'])
      g_json = open("http://gravatar.com/#{g_hash}.json").read rescue nil

      @author_gravatar[nickname] = Oj.load g_json if author && g_json

      @author_gravatar[nickname]
    end

    def author_photo nickname
      profile = author_gravatar nickname

      image_tag profile['entry'][0]['thumbnailUrl'] if profile
    end

    # Normalize tag names to lowercase & without spaces
    # (used for comparison purposes)
    def norm_tag(tag)
      tag.downcase.tr(' ', '')
    end

    # Calculate tag percentage based on minimum and maximum values
    # and return CSS for font scaling
    def tag_size_css count, min, max
      min_percent, max_percent = 100, 300

      size = min_percent + (count - min) * ((max_percent - min_percent) /  [(max - min), 1].max)

      "font-size:#{size}%;"
    end

    # Generate and cache a list of optimized tags
    def optimized_tags
      return $optimized_tags unless $optimized_tags.empty?

      $optimized_tags = blog.tags.keys.sort.uniq{ |t| norm_tag(t) }.compact.inject({}) do |result, tag|
        tag_count = blog.tags
          .select { |t| norm_tag(t) == norm_tag(tag) }
          .map { |t,d| d.count }.reduce(:+)

        result[tag] = tag_count unless tag.empty?

        result
      end
    end

    # Sort basic article data into lists of tags (and cache)
    def article_taglist
      return $article_taglist unless $article_taglist.empty?

      $article_taglist = blog.articles.sort_by(&:url).inject({}) do |result, article|
        article_tags = article.data.tags

        unless article_tags.nil?
          article_tags = article.data.tags.to_s.strip.split(',') if article_tags.is_a?(String)
          article_tags = article_tags.map { |t| t.parameterize.tr('-', '') }
          article_tags.each do |atag|
            result[atag] ||= []
            result[atag].push(url: article.url,
                              title: article.title.strip,
                              author: article.data.author,
                              date: article.date.to_date,
                              data: article.data)
          end
        end
        result
      end
    end

    # Find article by matching tags
    def articles_by_tag(searched_tag)
      # Find everything that matches words, regardless of case or space
      # "Open Source" == "opensource", etc.
      tag_matches = article_taglist.select do |tag, articles|
        tag == searched_tag.parameterize.tr('-', '')
      end

      # Join array(s) to just return results
      # then sort by date
      tag_matches
        .inject([]) { |result, d| result + d[1] }
        .sort_by { |t| t[:date] }
    end

  end
end

::Middleman::Extensions.register(:blog_helpers, BlogHelpers)
