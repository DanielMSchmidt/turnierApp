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
        latin_po: latin.pointsAtTime(point_of_time),
        latin_pl: latin.placingsAtTime(point_of_time),
        standard_po: standard.pointsAtTime(point_of_time),
        standard_pl: standard.placingsAtTime(point_of_time)
       }
      hash
    end
    tournaments
  end

  def getTournamentsData(couple)
    [{ y: "Turniere" ,l: couple.latin.dancedTournaments.count ,s: couple.standard.dancedTournaments.count }]
  end

  def getPlacingsData(couple)
    [{ y: "Platzierungen" ,l: couple.latin.placings ,s: couple.standard.placings }]
  end

  def getPointsData(couple)
    [{ y: "Punkte" ,l: couple.latin.points ,s: couple.standard.points }]
  end

  #               Line or Bar        Hash of keys
  #               |                  |
  def printGraph(type, field, data, keys)
    key_names = keys.keys.collect{|key| "'"+key.to_s+"'"}.join(", ")
    key_values = keys.values.collect{|value| "'"+value.to_s+"'"}.join(", ")

    str =  raw("document.addEventListener( 'DOMContentLoaded', function(){")
    str += raw("Morris.#{type.capitalize}({")
    str += raw("element: '#{field}',")
    str += raw("data: #{data.to_json},")
    str += raw("xkey: 'y',")
    str += raw("ykeys: [#{key_names}],")
    str += raw("labels: [#{key_values}]});")
    str += raw("});")
  end


  def tournamentDate(tournament)
    tournament.getDate.strftime("%d.%m.%Y") if tournament.date?
  end

  def tournamentTime(tournament)
    tournament.getDate.strftime("%H:%M") if tournament.date?
  end

  def tournamentAddress(tournament)
    raw tournament.address.gsub(/\s(\s*)/, ' ').split(", ").join("<br />") if tournament.address?
  end

end
