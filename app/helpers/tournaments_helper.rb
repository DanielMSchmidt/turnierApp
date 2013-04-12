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
    <td>#{placings(tournaments_of_year, :latin_placing)} / #{points(tournaments_of_year, :latin_points)}</td>
    <td>#{placings(tournaments_of_year, :standard_placing)} / #{points(tournaments_of_year, :standard_points)}</td>
    </tr>"
  end

  def placings(tournaments, filter = :placing)
    tournaments.collect(&filter).inject(:+) || 0
  end

  def points(tournaments, filter = :points)
    tournaments.collect(&filter).inject(:+) || 0
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

  def getProgressOverTimeData(couple)
    mergeProgressArrays(getProgressOverTime(couple.latin), getProgressOverTime(couple.standard))
  end

  def mergeProgressArrays(latin_array, standard_array)
    (latin_array + standard_array).sort{ |a,b| a[:y] <=> b[:y] }
  end

  def getProgressOverTime(progress)
    progress.tournaments.reject{|tournament| tournament.upcoming?}.collect do |tournament|
      point_of_time = tournament.date
      {
        y: point_of_time.strftime("%d.%m.%y"),
        po: progress.points_at_time(point_of_time),
        pl: progress.placings_at_time(point_of_time)
       }
    end
  end

  def getTournamentsData(couple)
    [{ b: "Turniere" ,l: couple.latin.tournaments.count ,s: couple.standard.tournaments.count }]
  end

  def getPlacingsData(couple)
    [{ b: "Platzierungen" ,l: couple.latin.placings ,s: couple.standard.placings }]
  end

  def getPointsData(couple)
    [{ b: "Punkte" ,l: couple.latin.points ,s: couple.standard.points }]
  end

end
