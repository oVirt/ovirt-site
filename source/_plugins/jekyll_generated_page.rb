# using PageWithoutAFile directly is not sufficient to generate a page
# fully without any interference of templating and other processing
# altering newline types etc
class JekyllGeneratedPage < ::Jekyll::PageWithoutAFile
  def initialize(site, dir, name, content)
    @site = site
    @dir = dir
    @name = name
    @content = content

    @base = site.source
    self.process(@name)

    self.content = @content
    self.data = {
      'generated' => true,
    }
  end
end
