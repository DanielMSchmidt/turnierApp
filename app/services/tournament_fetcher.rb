class TournamentFetcher
  def initialize(number)
    @number = number
    @mechanize = Mechanize.new
    @tournament_data = self.get_tournament_data
  end

  def get_tournament_data
    hash = extract_results(get_result_page(@number))
    hash[:number] = @number
    hash
  end

  def get_result_page(number)
    @mechanize.get("http://appsrv.tanzsport.de/td/db/turnier/einzel/suche")
    search_form = @mechanize.page.forms.last

    search_form.nr = number
    search_form.submit

    @mechanize.page
  end

  def extract_results(page)
    raw_data = get_raw_data(page)
    extracted_results = {}
    raw_data.each do |key, value|
      extracted_results[key] = send("extract_#{key}", value)
    end
    join_time_and_date extracted_results
  end

  def join_time_and_date hash
    time = hash.delete(:time)
    hash[:date] = DateTime.parse("#{hash.delete(:date)} #{time}")
    hash
  end

  def extract_kind(content)
    content.text
  end

  def extract_date(content)
    content.text.scan(/^\d{1,2}.\d{1,2}.\d{4}/).first
  end

  def extract_time(content)
    content.text.scan(/\d{1,2}:\d{2}/).first
  end

  def extract_notes(content)
    content.text
  end

  def extract_address(content)
    content.text.split("\t").join("").split("\n").join(" ").strip
  end

  def get_raw_data(page)
    kind = page.search(".markierung .turnier")
    date = page.search(".kategorie")
    time = page.search(".markierung .uhrzeit")
    notes = page.search(".markierung .bemerkung")
    address = page.search(".ort")

    {kind: kind, date: date, time: time, notes: notes, address: address}
  end
end