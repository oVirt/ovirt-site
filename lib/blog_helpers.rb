# Various helpers to enhance Middleman-based blogging
class BlogHelpers < Middleman::Extension
  def initialize(app, options_hash = {}, &block)
    require 'oj'
    require 'digest/md5'

    super
  end

  helpers do
    def author_name(nickname)
      data.authors[nickname] ? data.authors[nickname].name : nickname
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

      author_card nickname
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

      author_gravatar nickname
    end

    def author_photo(nickname)
      profile = author_gravatar nickname

      image_tag profile['entry'][0]['thumbnailUrl'] if profile
    end
  end
end

::Middleman::Extensions.register(:blog_helpers, BlogHelpers)
