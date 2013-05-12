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

  # TODO: refactor via decorator

  def getProgressOverTimeData(couple)
    getProgressOverTime(couple.latin, couple.standard).sort{ |a,b| a[:y] <=> b[:y] }
  end

  def getProgressOverTime(latin, standard)
    tournaments = (latin.tournaments + standard.tournaments).reject{|tournament| tournament.upcoming?}.collect do |tournament|
      point_of_time = tournament.date
      hash = {
        y: point_of_time.strftime("%Y-%m-%d"),
        latin_po: latin.points_at_time(point_of_time),
        latin_pl: latin.placings_at_time(point_of_time),
        standard_po: standard.points_at_time(point_of_time),
        standard_pl: standard.placings_at_time(point_of_time)
       }
      hash
    end
    tournaments
  end

  def getTournamentsData(couple)
    [{ y: "Turniere" ,l: couple.latin.danced_tournaments.count ,s: couple.standard.danced_tournaments.count }]
  end

  def getPlacingsData(couple)
    [{ y: "Platzierungen" ,l: couple.latin.placings ,s: couple.standard.placings }]
  end

  def getPointsData(couple)
    [{ y: "Punkte" ,l: couple.latin.points ,s: couple.standard.points }]
  end

  #               Line or Bar        Hash of keys
  #               |                  |
  def print_graph(type, field, data, keys)
    key_names = keys.keys.collect{|key| "'"+key.to_s+"'"}.join(", ")
    key_values = keys.values.collect{|value| "'"+value.to_s+"'"}.join(", ")

    str = raw ("Morris.#{type.capitalize}({")
    str += raw("element: '#{field}',")
    str += raw("data: #{data.to_json},")
    str += raw("xkey: 'y',")
    str += raw("ykeys: [#{key_names}],")
    str += raw("labels: [#{key_values}]});")
  end

end
