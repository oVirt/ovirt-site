xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = data.site.domain[/http:/] ? data.site.domain : "http://#{data.site.domain}"
  xml.title data.site.name
  xml.subtitle data.site.subtitle
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name data.site.owner }

  blog.articles[0..5].each do |article|
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
