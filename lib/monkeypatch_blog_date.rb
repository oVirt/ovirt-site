## Monkeypatch: make mismatched dates fail gracefully, not bomb out
#
# Original code is at:
# https://github.com/middleman/middleman-blog/blob/master/lib/middleman-blog/blog_article.rb#L179
#
# (Please update if the code differs)

Middleman::Blog::BlogArticle.module_eval do
  def date
    return @_date if @_date

    frontmatter_date = data['date']

    # First get the date from frontmatter
    if frontmatter_date.is_a? Time
      @_date = frontmatter_date.in_time_zone
    else
      @_date = Time.zone.parse(frontmatter_date.to_s)
    end

    # Next figure out the date from the filename
    source_vars = blog_data.source_template.variables

    if source_vars.include?('year') &&
      source_vars.include?('month') &&
      source_vars.include?('day')

      filename_date = Time.zone.local(path_part('year').to_i, path_part('month').to_i, path_part('day').to_i)
      if @_date
        unless @_date.to_date == filename_date.to_date
          # Don't cause an error here; just fallback to using the
          # metadata date

          puts "Warning: Frontmatter date (#{@_date}) mismatch in #{path}"

          # Original code:
          # raise "The date in #{path}'s filename doesn't match the date in its frontmatter"
        end
      else
        @_date = filename_date.to_time.in_time_zone
      end
    end

    raise "Blog post #{path} needs a date in its filename or frontmatter" unless @_date

    @_date
  end
end
