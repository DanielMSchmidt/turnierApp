module ApplicationHelper
  def getUserNamesAndPlaceholder
    User.find(:all, select: "name").collect{|user| user.name} << 'Noch nicht eingetragen'
  end
end
