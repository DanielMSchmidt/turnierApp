# -*- encoding : utf-8 -*-
module TournamentsHelper
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


  def tournament_date(tournament)
    tournament.get_date.strftime("%d.%m.%Y") if tournament.date?
  end

  def tournament_time(tournament)
    tournament.get_date.strftime("%H:%M") if tournament.date?
  end

  def tournament_adress(tournament)
    raw tournament.address.gsub(/\s(\s*)/, ' ').split(", ").join("<br />") if tournament.address?
  end

end
