require_relative '../../lib/confcal'

module OVirt
  class EventsPagesGenerator < ::Jekyll::Generator
    def generate(site)
      # yearly pages
      site.data.events.keys.each do |year|
        next unless year =~ /^\d+$/

        page = ::Jekyll::PageWithoutAFile.new(site, site.source, 'events', "#{year}.html")
        page.content = "{% haml events_index.haml %}"
        page.data = {
          'layout' => 'application',
          'title' => "#{year} Events",
          'year' => year,
          'generated' => true,
        }
        site.pages << page
      end

      # JSON data file for the calendar widget
      site.pages << JekyllGeneratedPage.new(site, 'events', 'calendar.json', gen_calendar_json(site))

      # ICS file
      site.pages << JekyllGeneratedPage.new(site, 'events', 'all.ics', gen_calendar_ics(site))
    end
  end
end
