# -*- encoding : utf-8 -*-
class TournamentFetcher
  attr_accessor :kind, :time, :date, :notes, :address
  def initialize(number)
    @number = number
    @mechanize = Mechanize.new
    @tournament_data = get_cached_tournament_data
  end

  def run
    @tournament_data
  end

  def rerun
    Rails.cache.delete("tf-#{@number}")
    get_cached_tournament_data
  end

  def get_cached_tournament_data
    return Rails.cache.fetch("tf-#{@number}") do
      self.get_tournament_data
    end
  end

  def get_tournament_data
    Rails.logger.debug "Tournament data is fetching for #{@number}"
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
      extracted_results[key] = send("extract_#{key}", value) unless value.nil?
    end
    join_time_and_date extracted_results
  end

  def join_time_and_date hash
    time = hash.delete(:time)
    hash[:date] = DateTime.parse("#{hash.delete(:date)} #{time}")
    hash
  end

  def extract_kind(content)
    convert_to_text(content)
  end

  def extract_date(content)
    convert_to_text(content).scan(/^\d{1,2}.\d{1,2}.\d{4}/).first
  end

  def extract_time(content)
    convert_to_text(content).scan(/\d{1,2}:\d{2}/).first
  end

  def extract_notes(content)
    convert_to_text(content)
  end

  def extract_address(content)
    convert_to_text(content).split("\t").join("").split("\n").delete_if{|x| x.blank? }.join(" ")
  end

  def convert_to_text(content)
    if content.class ==  String
      content
    else
      content.text
    end
  end

  def get_raw_data(page)
    #Test id its a multiline tournament
    if page.search(".markierung .uhrzeit").first.text.empty?
      puts "This Tournament seems to be a big one: #{@number}"

      page.search(".turniere tr").each do |single_tournament|
        next_kind = get_subelement_if_available(single_tournament, ".turnier")
        self.kind = next_kind unless next_kind.nil? || next_kind.blank?

        next_time = get_subelement_if_available(single_tournament, ".uhrzeit")
        self.time = next_time unless next_time.nil? || next_time.blank?

        break if single_tournament.attributes().has_key?('class')
      end
    else
      self.kind = page.search(".markierung .turnier")
      self.time = page.search(".markierung .uhrzeit")
    end
    self.notes = page.search(".turniere tr .bemerkung").to_a.collect(&:text).reject{|x| x.nil? || x.blank?}.join("\n")
    self.date = page.search(".kategorie")
    self.address = page.search(".ort")
    {kind: self.kind, date: self.date, time: self.time, notes: self.notes, address: self.address}
  end

  def get_subelement_if_available(element, selector)
    unless element.search(selector).first.nil?
      return element.search(selector).first.text
    else
      return nil
    end
  end
end
