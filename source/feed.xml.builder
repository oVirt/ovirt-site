xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = data.site.domain[/http:/] ? data.site.domain : "http://#{data.site.domain}"
  xml.title data.site.name
  #xml.subtitle data.site.subtitle
  xml.subtitle defined?(tag_name) ? "Tag: #{tag_name.titleize}" : nil
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated blog.articles.first ? blog.articles.first.date.to_time.iso8601 : ""
  xml.author { xml.name data.site.owner }

  # Optionally filter by tag
  relevant_articles = if defined? tag_name
    blog.articles.select {|a| a.data.tags && a.data.tags.detect {|t| t.downcase == tag_name.downcase}}
  else
    blog.articles
  end

  relevant_articles.reject! {|a| !a.published? }

  relevant_articles.take(blog_controller.options.per_page).each do |article|
    nickname = article.data.author

    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author {xml.name data.authors[nickname] ? data.authors[nickname].name : nickname}
      # xml.summary demote_headings(article.summary), "type" => "html"
      xml.content demote_headings(article.body), "type" => "html"
    end
  end
end
