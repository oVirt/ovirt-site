# This file contains a filter which rewrites links to match the preview build locations.
# It fixes the links that are not properly prefixed with the base URL.

$prefix = "/"

Jekyll::Hooks.register :site, :after_init do |site|
    $prefix = site.config["baseurl"]
end

Jekyll::Hooks.register([:pages, :posts], :post_render) do |post|
    # Add base URL prefixes to all links that start with a slash.
    post.output = post.output.gsub(/href="\//, 'href="' + $prefix + '/')
    post.output = post.output.gsub(/href='\//, 'href=\'' + $prefix + '/')
    post.output = post.output.gsub(/src="\//, 'src="' + $prefix + '/')
    post.output = post.output.gsub(/src='\//, 'src=\'' + $prefix + '/')
    if $prefix != "" then
      # Above we also replaced some links that were already prefixed, let's undo that.
      post.output = post.output.gsub($prefix+$prefix, $prefix)
    end
end
