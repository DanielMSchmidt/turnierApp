require 'mechanize'
require 'nokogiri'

class TournamentFetcher
  def TournamentFetcher.find_by_number(number)
    agent = Mechanize.new
    agent.get("http://appsrv.tanzsport.de/td/db/turnier/einzel/suche")
    form = agent.page.forms.last
    form.nr = number
    form.submit

    agent.page.search(".veranstaltung").each do |event|
      event.search(".ort a").each do |link|
        out[url] = link.attributes["href"].value
        out[address] = url.slice(30..url.length)
      end
      out[date] = event.search(".kategorie").first.text.slice(0..9)
    end
    agent.page.search(".markierung").each do |item|
      out[tournament] = item.search(".turnier").first.text
      out[time] = item.search(".uhrzeit").first.text
      out[notes] = item.search(".bemerkung").first.text
    end

    return out
  end
end