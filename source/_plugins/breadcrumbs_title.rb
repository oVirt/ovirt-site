require 'active_support/core_ext/string/inflections'

# it absolutely needs to run before the breadcrumbs plugin so please care about the priority
Jekyll::Hooks.register :site, :pre_render, priority: 25 do |site, payload|
  (site.documents + site.pages).each do |el|
    if not el.data['title'] and not el.data['crumbtitle']
      el.data['crumbtitle'] = el.url.split('/').last.titleize
    end
  end
end
