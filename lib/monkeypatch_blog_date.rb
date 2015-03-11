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
    @_date = if frontmatter_date.is_a? Time
               frontmatter_date.in_time_zone
             else
               Time.zone.parse(frontmatter_date.to_s)
             end

    # Next figure out the date from the filename
    source_vars = blog_data.source_template.variables

    if source_vars.include?('year') &&
       source_vars.include?('month') &&
       source_vars.include?('day')

      filename_date = Time.zone.local path_part('year').to_i,
                                      path_part('month').to_i,
                                      path_part('day').to_i

      if @_date
        unless @_date.to_date == filename_date.to_date
          # Don't cause an error here; just fallback to using the
          # metadata date

          puts "Warning: Frontmatter date (#{@_date}) mismatch in #{path}"
        end
      else
        @_date = filename_date.to_time.in_time_zone
      end
    end

    unless @_date
      fail "Blog post #{path} needs a date in its filename or frontmatter"
    end

    @_date
  end
end
