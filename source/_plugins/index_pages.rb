module OVirt
  class IndexPage < ::Jekyll::PageWithoutAFile
    def initialize(site, dir)
      @site = site

      @base = site.source
      @dir = dir
      @name = "index.html"
      self.process(@name)

      self.content = "{% haml index.haml %}"

      self.data = {
        'layout' => 'default',
        'generated' => true,
      }
    end
  end

  class IndexPagesGenerator < ::Jekyll::Generator
    def generate(site)
      # list of all directories
      dirs = Set.new
      site.pages.each do |p|
        next unless p.html?

        # insert all intermediate paths as some directories may only contain subdirectories
        d = p.dir.sub(/(.)\/$/, '\1')
        until d == '/'
          dirs << d
          d = File.dirname(d)
        end
      end

      # remove directories with index
      site.pages.each do |p|
        d = p.dir.sub(/(.)\/$/, '\1')

        dirs.delete(d) if p.index?
      end

      dirs.each do |d|
        site.pages << IndexPage.new(site, d)
      end
    end
  end
end
