module ApplicationHelper

  def getUserNamesAndPlaceholder
    User.find(:all, select: "name").collect{|user| user.name} << 'Noch nicht eingetragen'
  end

  def setValueTo(value_model)
    if value_model.nil?
      'Noch nicht eingetragen'
    else
      value_model.name
    end
  end

end
