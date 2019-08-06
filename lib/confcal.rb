require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/conversions'
require 'chronic'
require 'nokogiri'
require 'date'
require 'icalendar'


def markdown_to_html(content)
  return "" if content.blank?
  md_converter = Jekyll.sites.first.find_converter_instance(Jekyll::Converters::Markdown)
  md_converter.convert(content)
end

def html_to_plaintext(content)
  Nokogiri::HTML(content).text.strip
end

def markdown_to_plaintext(content)
  html_to_plaintext(markdown_to_html(content))
end

def tz_lookup time_zone
  return @tzc[time_zone] || time_zone if defined? @tzc

  ## Build timezone abbriviation dictionary
  @tzc ||= {}

  # Prioritize US & Indian timezones
  (ActiveSupport::TimeZone.us_zones + [ActiveSupport::TimeZone.new('Asia/Kolkata')] + ActiveSupport::TimeZone.all).each do | zone|
    daylight_abbr = zone.parse('Aug 1').strftime('%Z')
    standard_abbr = zone.parse('Dec 1').strftime('%Z')

    # It's important to give priority to "standard" time,
    # as there are some clashes
    # (Sadly, that's just the way it is)
    @tzc[standard_abbr] = zone.name unless @tzc[standard_abbr]
    @tzc[daylight_abbr] = zone.name unless @tzc[daylight_abbr]
  end

  tz_lookup time_zone
end

def strftime_zone time_string, time_zone = "UTC", time_fmt
  old_zone = Time.zone rescue "UTC"
  Time.zone = tz_lookup time_zone rescue "UTC"

  result = Time.zone.parse(time_string).strftime(time_fmt)

  Time.zone = old_zone

  result
end

def vcal_time time_string, time_zone = "UTC"
  old_zone = Time.zone rescue "UTC"
  Time.zone = tz_lookup time_zone rescue "UTC"
  Chronic.time_class = Time.zone

  result = Chronic::parse(time_string).utc.strftime('%Y%m%dT%H%M%SZ')

  Time.zone = old_zone

  result
end

def sort_events events
  sorted_events = {}

  # FIXME: Sort talks also

  events = events.each do |year_label, year|

    sorted_events[year_label] = year.sort_by do |conf_label, conf|
      talk_times = [ conf.start ]

      if conf.talks
        conf.talks.each do |talk|
          talk_time = Chronic::parse talk.start
          talk_times.push talk_time.to_date if talk_time
        end
      end

      # If no date in conf or talks: sort to bottom by faking far future
      talk_times.compact.min || "3000-1-1".to_date
    end

  end

  sorted_events
end

# Filter events to only include today + future events (and cache it)
def current_events events, time_start = Time.now, time_end = Time.now + 60*60*24*365
  date_start = time_start.to_date
  date_end = time_end.to_date

  if defined?($cur_ev) && $cur_ev[date_start] && $cur_ev[date_start][date_end]
    return $cur_ev[date_start][date_end]
  end

  $cur_ev ||= {}
  $cur_ev[date_start] ||= {}

  $cur_ev[date_start][date_end] = events.each_with_object({}) do |(year_label, year), h|
    if year_label[/\d{4}/]

      h[year_label] = year.select do |conf_label, conf|
        matches = false

        if conf.start
          conf_date = Chronic::parse(conf.end || conf.start)
          matches = true if conf_date >= date_start && conf_date < date_end
        end

        if conf.talks and not matches
          conf.talks.each do |talk|
            talk_date = Chronic::parse(talk.end)
            if talk.end && talk_date >= date_start && talk_date < date_end
              matches = true
            end
          end
        end

        matches
      end
    end

  end

  $cur_ev[date_start][date_end].reject! {|year_label, year| year.empty?}

  $cur_ev[date_start][date_end] = sort_events $cur_ev[date_start][date_end]

  current_events events, date_start, date_end
end

# Return conferences that match a regular expression filter
def confs_match(filter, events)
  return events unless filter

  filter = /#{filter}/i if filter.class == String

  events.each_with_object({}) do |(year, confs), h|
    h[year] = confs.select do |label, conf|
      label.match(filter) || conf.to_yaml.match(filter)
    end
  end
end

def pretty_date(sometime, length = 'long')
  return unless sometime

  sometime = Time.parse(sometime) if sometime.class == String

  format = length == 'short' ? '%a %e %b' : '%A %e %B'
  format << ' %Y' unless sometime.year == Time.now.year

  sometime.to_time.strftime(format) rescue ''
end

# generate JSON data for the calendar widget on the events page
# see FullCalendar (https://fullcalendar.io/)
def gen_calendar_json(site)
  conferences = []

  confs_match(site.data.site.events_filter, site.data.events).each do |year_label, year|

    if year_label[/\d{4}/]

      conferences += year.map do |conf_label, conf|

        time_pool = [
          Chronic::parse(conf.start),
          Chronic::parse(conf.end)
        ]

        if conf.talks
          conf.talks.each do |talk|
            time_pool.push Chronic::parse(talk.start)
            time_pool.push Chronic::parse(talk.end)
          end
        end

        time_pool.compact!

        if time_pool.max.nil?
          current = false
        else
          current = time_pool.max.to_time > Time.now
        end

        page = "/events/#{year_label}/"

        if conf.type && conf.type == 'series'
          if conf.talks
            conf.talks.each do |talk|
              fragment = "##{conf_label.parameterize}--#{talk.title.parameterize}"

              begin
                item = {
                  title: talk.title,
                  start: Chronic::parse(talk.start),#.strftime("%Y-%m-%d"),
                  speaker: talk.speaker,
                  end: Chronic::parse(talk.end),#.strftime("%Y-%m-%d"),
                  url: current ? fragment : page + fragment,
                  className: current ? "current" : "old",
                  location: talk.location,
                  tags: talk.tags || conf.tags,
                  allDay: false
                }

                conferences.push item
              rescue
              end
            end
          end

          nil # Conference-level data shouldn't be returned
        else
          fragment = "##{conf_label.parameterize}"

          className = current ? 'current ' : 'old '
          className += conf[:allDay].nil? ? 'fc-x-conf' : 'fc-x-talk'
          {
            title: conf.name,
            speaker: conf.speaker,
            start: conf.start || time_pool.min.to_date,
            end: conf.end || conf.start || time_pool.max.to_date,
            url: current ? fragment : page + fragment,
            className: className,
            location: conf.location,
            tags: conf.tags,
            allDay: conf[:allDay].nil?,
          }
        end
      end

    end

  end

  conferences.compact.to_json
end

# generate ICS data for the events page
def gen_calendar_ics(site)
  cal = Icalendar::Calendar.new

  cal.x_wr_calname = site.config['title']

  confs_match(site.data.site.events_filter, site.data.events).each do |year_label, year|

    if year_label[/\d{4}/]

      year.each do |conf_label, conf|

        conference = Icalendar::Event.new

        conference.uid = conference.uid.gsub(/@.*/, "@#{site.data.site.domain}")

        conference.summary     = conf.name
        conference.location    = conf.location
        conference.description = markdown_to_plaintext(conf.description).gsub(/\n/, '')

        conference.start = conf.start

        # DTEND is unintuitively day + 1 (next day) for date-only events
        # according to RFC 5545 section 3.6.1 (page 53)
        conference.end   = conf.end + 1 if conf.end

        if conf.talks
          talk_times = []

          conf.talks.each do |talk|
            event = Icalendar::Event.new

            event.uid = event.uid.gsub(/@.*/, "@#{site.data.site.domain}")

            description_text = "Speaker: #{talk.speaker}. #{talk.description.to_s.strip}"

            event.summary     = talk.title.gsub(/:/, '\\:')
            event.location    = talk.location || conf.location
            event.description = markdown_to_plaintext(description_text).gsub(/\n/, '')

            if talk.start && talk.end
              timezone = tz_lookup(talk.timezone || conf.timezone || talk.start[/[a-zA-Z+0-9:]+$/])

              # Workaround for IST collision
              if talk.start =~ /IST$/ && event.location =~ /UK|United Kingdom|Dublin|Edinburgh|Ireland/i
                timezone = "Europe/Dublin"
              elsif talk.start =~ /IST$/
                timezone = "Asia/Kolkata"
              end

              event.start = vcal_time talk.start, timezone
              event.end   = vcal_time talk.end, timezone

              # Keep track of all talk times, so conf. dates can be optional
              talk_times.push event.start
              talk_times.push event.end

              # Only add talks with date and time
              # There are some TBA events that are displayed,
              # but those don't belong in an .ics file
              cal.add_event(event)
            end
          end

          # Rewrite conference start and end based on talks,
          # if start and end times were not given
          if talk_times.min && !conference.start
            conference.start = talk_times.min.split(/T/).first.to_date
          end
          if talk_times.max && !conference.end
            conference.end = talk_times.max.split(/T/).first.to_date + 1
          end

        end

        cal.add_event(conference)
      end

    end

  end

  cal.to_ical
end

