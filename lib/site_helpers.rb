# Various useful functions for Middleman-based sites
class SiteHelpers < Middleman::Extension
  def initialize(app, options_hash = {}, &block)
    super
  end

  helpers do
    require 'open-uri/cached'

    def pretty_date(sometime, length = 'long')
      return unless sometime

      sometime = Time.parse(sometime) if sometime.class == String

      format = length == 'short' ? '%a %e %b' : '%A %e %B'
      format << ' %Y' unless sometime.year == Time.now.year

      sometime.to_time.strftime(format) rescue ''
    end

    def word_unwrap(content)
      content.to_s
        .gsub(/\n\n/, '!ಠ_ಠ!')
        .gsub(/\n/, ' ')
        .squeeze(' ')
        .gsub(/!ಠ_ಠ!/, "\n\n")
    end

    def html_to_plaintext(content)
      Nokogiri::HTML(content).text.strip
    end

    def markdown_to_html(content)
      return unless content

      Tilt['markdown'].new(config[:markdown]) { content.strip }.render
    end

    def markdown_to_plaintext(content)
      word_unwrap html_to_plaintext(markdown_to_html(content))
    end

    # Use the title from frontmatter metadata,
    # or peek into the page to find the H1,
    # or fallback to a filename-based-title
    def discover_title(page = current_page)
      return page.data.title unless page.data.title.nil?

      page.render(layout: false).match(/<h[1-2][^>]*>(.*?)<\/h[1-2]>/m) do |m|
        m ? html_to_plaintext(m[1].strip) : page.url.split(/\//).last.titleize
      end
    end

    def demote_headings(content)
      h_add = case content
              when /<h1>/
                2
              when /<h2>/
                1
              end

      if h_add
        content.to_str.gsub(/<(\/?)h([1-6])>/) do |_m|
          "<#{Regexp.last_match(1)}h#{Regexp.last_match(2).to_i + h_add}>"
        end.html_safe
      else
        content
      end
    end

    # Convert a Nokogiri fragment's H2s to a linked table of contents
    def h2_to_toc(nokogiri_fragment, filename)
      capture_haml do
        haml_tag :ol do
          nokogiri_fragment.css('h2').each do |heading|
            haml_tag :li do
              haml_tag :a, href: "#{filename}/##{heading.attr('id')}" do
                # haml_content heading.content
                haml_concat heading.content
              end
            end
          end
        end
      end
    end

    # Pull in a Markdown document's ToC or generate one based on H2s
    def doc_toc(source_filename, someclass = '')
      current_dir = current_page.source_file.sub(/[^\/]*$/, '')
      tasks_md = File.read "#{current_dir}/#{source_filename}.md"
      doc = Nokogiri::HTML(markdown_to_html(tasks_md))
      toc = doc.css('#markdown-toc').attr(:id, '')

      # Rewrite all links in the ToC (only done if ToC exists)
      toc.css('li a').each do |link|
        link[:href] = "#{source_filename}/#{link[:href]}"
      end

      # ToC: Either in-page or (otherwise) generated
      toc = toc.any? ? toc : h2_to_toc(doc, source_filename)

      toc.attr(:class, "toc-interpage #{someclass}")
    end

    # Fetch and return the entries of an Atom or RSS feed
    def simple_feed(feed_url, limit = 10)
      feed = Feedjira::Feed.parse(open(feed_url).read)

      feed.entries.sort_by!(&:updated).reverse!

      feed.entries.take(limit)
    end

    # Build an unordered list based upon simple_feed
    # (HAML in Ruby makes for crazy nesting)
    def simple_feed_list(feed_url, limit = 10, meta = 'date')
      capture_haml do
        haml_tag :ul, class: 'feed-list' do
          simple_feed(feed_url, limit).each do |entry|
            meta_data = meta[/date/] ? entry.updated : entry[meta]

            haml_tag :li, class: 'feed-entry' do
              haml_tag :a, href: entry.url, class: 'feed-link' do
                haml_concat entry.title
              end

              unless meta.empty?
                haml_tag :span, class: "feed-meta meta-#{meta}" do
                  if defined? meta_data.strftime
                    haml_tag :time,
                             datetime: entry.updated.iso8601,
                             class: 'published' do
                               haml_concat meta_data.strftime('%Y-%m-%d')
                             end
                  else
                    haml_concat meta_data
                  end
                end
              end
            end
          end
        end
      end
    end

    def author_name(nick)
      data.authors[nick] ? data.authors[nick].name || nick : nick
    end

  end
end

::Middleman::Extensions.register(:site_helpers, SiteHelpers)
