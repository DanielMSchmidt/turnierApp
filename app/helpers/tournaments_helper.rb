module TournamentsHelper
  def print_stats(tournaments = [])
    tournaments.select!{|tournament| !tournament.upcoming?}

    return "Ohne Turniere gibt es keine Statistik" if tournaments.empty?
    str = "<table class='stats'><tr><th>Jahr</th><th>Turniere</th><th>Platzierungen</th><th>Punkte</th>"

    tournaments_by_year(tournaments).each do |year|
      str += print_year(year)
    end

    str += "</table>"
    return str
  end

  def tournaments_by_year(tournaments)
    out = []
    tournaments.each do |tournament|
      thisYear = tournament.date.to_datetime.year
      out[thisYear] ||= []
      out[thisYear].push(tournament)
    end
    return out.compact.reverse
  end

  def print_year(tournaments_of_year)
    return "<tr>
    <th>#{tournaments_of_year.first.date.to_datetime.year}</th>
    <td>#{tournaments_of_year.count}</td>
    <td>#{placings(tournaments_of_year)}</td>
    <td>#{points(tournaments_of_year)}</td>
    </tr>"
  end

  def placings(tournaments)
    count = 0
    tournaments.each do |tournament|
      place_for_placing = 3
      place_for_placing = 5 if start_class(tournament) == 'C'
      place_for_placing = 6 if start_class(tournament) == 'D'
      count += 1 if (tournament.place <= place_for_placing)
    end

    return count
  end

  def start_class(tournament)
    return tournament.kind.split(" ")[1]
  end

  def points(tournaments)
    sum = 0
    tournaments.each do |t|
      sum += [(t.participants - t.place), 20].min
      puts [(t.participants - t.place), 20].min
    end

    return sum
  end

  def tournament_date(tournament)
    tournament.date.to_datetime.strftime("%d.%m.%Y") unless tournament.date.nil?
  end

  def tournament_time(tournament)
    tournament.date.to_datetime.strftime("%H:%M") unless tournament.date.nil?
  end

  def tournament_adress(tournament)
    raw tournament.address.split(", ").join("<br />") unless tournament.address.nil?
  end
end
