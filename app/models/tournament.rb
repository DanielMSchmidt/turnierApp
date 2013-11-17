# -*- encoding : utf-8 -*-
class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  attr_accessible :number, :participants, :place, :progress_id, :address, :date, :kind, :notes, :enrolled, :notificated_about

  belongs_to :progress

  validates :number, presence: true, numericality: true
  validate :noDoubleTournamentsAreAllowed, on: :create

  before_destroy :sendMailIfEnrolledTournamentIsDeleted
  after_save :enhanceTournament

  def self.newForUser(params)
    tournament = Tournament.new()
    tournament.assignToUser(params[:tournament][:user_id])
    tournament.participants = params[:tournament][:participants]
    tournament.place        = params[:tournament][:place]
    tournament.number        = params[:tournament][:number]
    tournament.fillupMissingData

    tournament
  end

  def enhanceTournament
    EnhancementWorker.perform_async(self.id, self.number)
  end

  def noDoubleTournamentsAreAllowed
    Tournament.where(number: number, progress_id: progress_id).size == 0
    errors.add(:double, "was allready added") unless Tournament.where(:number => number, :progress_id => progress_id).size == 0
  end

  def belongsToUser(user)
    self.users.include?(user)
  end

  def couple
    self.progress.couple
  end

  def users
    [self.couple.man, self.couple.woman]
  end

  def assignToUser(user_id)
    user = User.find(user_id)

    if self.latin?
      id = user.activeCouple.latin.id
    else
      id = user.activeCouple.standard.id
    end

    self.progress_id = id
  end

  def belongsToClub(id)
    self.progress.couple.clubs.map{|c| c.id}.include?(id)
  end

  def incomplete?
    return (self.participants.nil? || self.participants == 0)  && (self.place.nil? || self.place == 0)
  end

  def getDate
    if self.date.nil?
      Date.today
    else
      self.date.to_datetime
    end
  end

  #TODO: Refactor to service object
  def fillupMissingData
    #if particiants or place is given and it's not upcoming, set place or particiants to default value
    #set enrolled to false if it is upcoming
    logger.debug "test if I can fill up any data"
    if (self.incomplete?)
      logger.debug "detected an upcoming tournament - #{self.to_s}"
      self.upcoming?
    else
      logger.debug "filling up missing data for #{self.to_s}"
      self.participants ||= self.place
      self.place ||= self.participants
      logger.debug "filled up as #{self.to_s}"
    end
    self.setEnrollement
    self #for chaining
  end

  def setEnrollement
    self.enrolled = !self.upcoming?
  end

  def upcoming?
    self.getDate.future? && self.incomplete?
  end

  def behindTime?
    #true if its upcoming and it has been danced jet
    self.incomplete? && !self.upcoming?
  end

  def gotPlacing?
    return false if self.incomplete?

    placeForPlacing = 3
    placeForPlacing = 5 if self.start_class == 'C'
    placeForPlacing = 6 if self.start_class == 'D'

    return (self.place <= placeForPlacing) && (self.points >= 2)
  end

  def points
    participants = self.participants ||= 0
    place = self.place ||= 0
    [(participants - place) , 20].min
  end

  def start_class
    return self.kind[0..-4].chop
  end

  def latin?
    return self.kind.nil? || (self.kind[-3..-1] == "LAT")
  end

  def shouldSendANotificationMail?
    logger.debug "test if a notification mail should be sended about #{self.to_s}"
    return false if self.enrolled? || !(Date.today..(Date.today + 5.weeks)).include?(self.date.to_date)
    if !(((Date.today - 6.days)..Date.today).include?(self.notificated_about.to_date) unless self.notificated_about.nil?)
      logger.debug "a notification mail should be send about #{self.to_s}"
      return true
    end
  end

  def notificationSend
    self.notificated_about = Date.today
    self.save
    logger.debug "the notification was send for #{self.to_s} and the time was updated"
  end

  def isEnrolledAndNotDanced?
    self.enrolled? && self.upcoming?
  end

  def sendMailIfEnrolledTournamentIsDeleted
    # FIXME: NameError at /tournaments/5 undefined local variable or method `tournament' for #<Tournament:0x007fcfd0d0cbe8>
    logger.debug "sendMailIfEnrolledTournamentIsDeleted for #{self.to_s}"
    if self.isEnrolledAndNotDanced?
      club_owners_mailaddresses = self.users.first.clubs.collect{|x| x.owner}.compact.collect{|x| x.email}
      logger.debug "enrolled tournamentDeleted Mail was send to #{club_owners_mailaddresses.join(', ')}"
      NotificationMailer.enrolledTournamentWasDeleted(club_owners_mailaddresses, tournament).deliver
    end
    logger.debug "deleted tournament #{self.to_s}"
  end

  def placing
    if self.gotPlacing?
      1
    else
      0
    end
  end

  def to_s
    "Tournament ##{self.id} - date: #{self.date} - enrolled: #{self.enrolled} - notificated_about: #{self.notificated_about}"
  end

  def statusClasses
    if self.behindTime? && self.incomplete?
      classes = 'icons-missing_information'
    else
      classes ='icons-not_enrolled' unless self.enrolled?
    end
    classes ||= 'icons-ok'
    classes
  end

end
