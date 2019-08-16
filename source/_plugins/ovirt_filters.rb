module Jekyll
  module OVirtFilters
    def ovirt_toc(input)
      input.sub(/^## /, "\n1. tic\n{:toc}\n\n\\0")
    end
  end
end

Liquid::Template.register_filter(Jekyll::OVirtFilters)
