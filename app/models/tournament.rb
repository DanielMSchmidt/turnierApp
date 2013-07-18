# -*- encoding : utf-8 -*-
class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  attr_accessible :number, :participants, :place, :progress_id, :address, :date, :kind, :notes, :enrolled, :notificated_about
  belongs_to :progress

  validates :number, presence: true, numericality: true
  validate :no_double_tournaments_are_allowed, on: :create

  before_destroy :send_mail_if_enrolled_tournament_is_deleted

  def self.new_for_user(params)
    tournament_fetcher = TournamentFetcher.new(params[:tournament][:number])
    tournament = Tournament.new(tournament_fetcher.get_tournament_data)
    tournament.assign_to_user(params[:tournament][:user_id])
    tournament.participants = params[:tournament][:participants]
    tournament.place        = params[:tournament][:place]
    tournament.fillup_missing_data
    tournament
  end

  def no_double_tournaments_are_allowed
    Tournament.where(number: number, progress_id: progress_id).size == 0
    errors.add(:double, "was allready added") unless Tournament.where(:number => number, :progress_id => progress_id).size == 0
  end

  def is_from_user(user)
    self.users.include?(user)
  end

  def couple
    self.progress.couple
  end

  def users
    [self.couple.man, self.couple.woman]
  end

  def assign_to_user(user_id)
    user = User.find(user_id)

    if self.latin?
      id = user.activeCouple.latin.id
    else
      id = user.activeCouple.standard.id
    end

    self.progress_id = id
  end

  def belongs_to_club(id)
    self.progress.couple.clubs.map{|c| c.id}.include?(id)
  end

  def incomplete?
    return self.participants.nil? && self.place.nil?
  end

  def get_date
    self.date.to_datetime
  end

  #TODO: Refactor to service object
  def fillup_missing_data
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
    self.set_enrollement
    self #for chaining
  end

  def set_enrollement
    self.enrolled = !self.upcoming?
  end

  def upcoming?
    self.get_date.future?
  end

  def behind_time?
    #true if its upcoming and it has been danced jet
    self.incomplete? && !self.upcoming?
  end

  def got_placing?
    return false if self.incomplete?

    place_for_placing = 3
    place_for_placing = 5 if self.start_class == 'C'
    place_for_placing = 6 if self.start_class == 'D'

    return (self.place <= place_for_placing) && (self.points >= 2)
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
    return self.kind[-3..-1] == "LAT"
  end

  def should_send_a_notification_mail?
    logger.debug "test if a notification mail should be sended about #{self.to_s}"
    return false if self.enrolled? || !(Date.today..(Date.today + 5.weeks)).include?(self.date.to_date)
    if !(((Date.today - 6.days)..Date.today).include?(self.notificated_about.to_date) unless self.notificated_about.nil?)
      logger.debug "a notification mail should be send about #{self.to_s}"
      return true
    end
  end

  def notification_send
    self.notificated_about = Date.today
    self.save
    logger.debug "the notification was send for #{self.to_s} and the time was updated"
  end

  def is_enrolled_and_not_danced?
    self.enrolled? && self.upcoming?
  end

  def send_mail_if_enrolled_tournament_is_deleted
    logger.debug "send_mail_if_enrolled_tournament_is_deleted for #{tournament.to_s}"
    if tournament.is_enrolled_and_not_danced?
      club_owners_mailaddresses = tournament.users.first.clubs.collect{|x| x.owner}.compact.collect{|x| x.email}
      logger.debug "enrolled tournamentDeleted Mail was send to #{club_owners_mailaddresses.join(', ')}"
      NotificationMailer.enrolledTournamentWasDeleted(club_owners_mailaddresses, tournament).deliver
    end
    logger.debug "deleted tournament #{tournament.to_s}"
  end

  def placing
    if self.got_placing?
      1
    else
      0
    end
  end

  def latin_placing
    self.placing if self.latin?
  end

  def standard_placing
    self.placing unless self.latin?
  end

  def latin_points
    self.points if self.latin?
  end

  def standard_points
    self.points unless self.latin?
  end

  def to_s
    "Tournament ##{self.id} - date: #{self.date} - enrolled: #{self.enrolled} - notificated_about: #{self.notificated_about}"
  end
end
