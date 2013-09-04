# -*- encoding : utf-8 -*-
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

  def ga_button_link_to(html, link, data, domain, action, classes="")
    ga_event = "_gaq.push(['_trackEvent', '#{domain}', '#{action}']);"
    link_to html, link, role: 'button', data: data, onClick: ga_event, :class => classes
  end
end
