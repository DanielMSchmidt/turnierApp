json.array! @tournaments do |tournament|
  json.(tournament, :number, :placing, :points, :address, :date, :kind, :place, :participants, :status)
end