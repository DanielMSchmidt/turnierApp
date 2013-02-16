#encoding: utf-8
class HomeController < ApplicationController
  def index
  end

  def impressum
    @active_page = 'impressum'
  end
end
