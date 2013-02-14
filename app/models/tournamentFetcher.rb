require 'mechanize'
require 'nokogiri'

class TournamentFetcher
  def self.find_by_number(number)
    return nil if number.nil? || number == ""

    agent = Mechanize.new
    agent.get("http://appsrv.tanzsport.de/td/db/turnier/einzel/suche")
    form = agent.page.forms.last
    form.nr = number
    form.submit

    out = {}

    agent.page.search(".veranstaltung").each do |event|
      event.search(".ort a").each do |link|
        url = link.attributes["href"].value
        out[:address] = url.slice(30..url.length)
      end
      @date = event.search(".kategorie").first.text.slice(0..9)
    end

    agent.page.search(".markierung").each do |item|

      if item.search(".uhrzeit").first.text.empty?
        puts "This Tournament seems to be a big one: #{number}"
        item.parent.children.each do |all_tournaments|
          next_kind = all_tournaments.search(".turnier").first.text
          next_time = all_tournaments.search(".uhrzeit").first.text
          next_notes = all_tournaments.search(".bemerkung").first.text

          out[:kind] = next_kind unless next_kind.empty?
          @time = next_time unless next_time.empty?
          out[:notes] = next_notes unless next_notes.empty?

          break if all_tournaments.attributes().has_key?('class')
        end

      else
        out[:kind] = item.search(".turnier").first.text
        @time = item.search(".uhrzeit").first.text
        out[:notes] = item.search(".bemerkung").first.text
      end
    end

    out[:date] = DateTime.parse "#{@time} #{@date}"

    return out
  end
end