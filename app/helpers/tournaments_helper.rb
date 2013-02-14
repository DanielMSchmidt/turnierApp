module TournamentsHelper
  def print_stats(tournaments = [])
    finished_tournaments = tournaments.select{|tournament| !tournament.upcoming?}

    return "Ohne getanzte Turniere gibt es keine Statistik" if finished_tournaments.empty?
    str = "<table class='stats'><tr><th>Jahr</th><th>Turniere</th><th>Platzierungen</th><th>Punkte</th><th>Latein (Platzierungen/Punkte)</th><th>Standard (Platzierungen/Punkte)</th>"

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
    <td>#{latin_placings(tournaments_of_year)} / #{latin_points(tournaments_of_year)}</td>
    <td>#{standard_placings(tournaments_of_year)} / #{standard_points(tournaments_of_year)}</td>
    </tr>"
  end

  def placings(tournaments)
    tournaments.collect{|x| 1 if x.got_placing?}.inject(:+) || 0
  end

  def latin_placings(tournaments)
    tournaments.collect{|x| 1 if x.got_placing? && x.latin?}.inject(:+) || 0
  end

  def standard_placings(tournaments)
    tournaments.collect{|x| 1 if x.got_placing? && !x.latin?}.inject(:+) || 0
  end

  def points(tournaments)
    tournaments.collect{|x| x.points}.inject(:+)
  end

  def latin_points(tournaments)
    tournaments.collect{|x| x.points if x.latin?}.inject(:+) || 0
  end

  def standard_points(tournaments)
    tournaments.collect{|x| x.points unless x.latin?}.inject(:+) || 0
  end

  def tournament_date(tournament)
    tournament.get_date.strftime("%d.%m.%Y") if tournament.date?
  end

  def tournament_time(tournament)
    tournament.get_date.strftime("%H:%M") if tournament.date?
  end

  def tournament_adress(tournament)
    raw tournament.address.split(", ").join("<br />") if tournament.address?
  end
end
