module TournamentsHelper
  def print_stats(tournaments = [])
    finished_tournaments = tournaments.select{|tournament| !tournament.upcoming?}

    return "Ohne getanzte Turniere gibt es keine Statistik" if finished_tournaments.empty?
    str = "<table class='stats'><tr><th>Jahr</th><th>Turniere</th><th>Platzierungen</th><th>Punkte</th>"

    tournaments_by_year(finished_tournaments).each do |year|
      str += print_year(year)
    end

    str += "</table>"
    return str
  end

  def tournaments_by_year(tournaments)
    out = []
    tournaments.each do |tournament|
      thisYear = tournament.get_date.year
      out[thisYear] ||= []
      out[thisYear].push(tournament)
    end
    return out.compact.reverse
  end

  def print_year(tournaments_of_year)
    return "<tr>
    <th>#{tournaments_of_year.first.get_date.year}</th>
    <td>#{tournaments_of_year.count}</td>
    <td>#{placings(tournaments_of_year)}</td>
    <td>#{points(tournaments_of_year)}</td>
    </tr>"
  end

  def placings(tournaments)
    count = 0
    tournaments.each do |tournament|
      count += 1 if tournament.got_placing?
    end

    return count
  end

  def points(tournaments)
    tournaments.collect{|x| x.points}.inject(:+)
  end

  def tournament_date(tournament)
    tournament.get_date.strftime("%d.%m.%Y") unless tournament.date.nil?
  end

  def tournament_time(tournament)
    tournament.get_date.strftime("%H:%M") unless tournament.date.nil?
  end

  def tournament_adress(tournament)
    raw tournament.address.split(", ").join("<br />") unless tournament.address.nil?
  end
end
