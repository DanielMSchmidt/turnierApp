class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  default_scope includes(:user)
  attr_accessible :number, :participants, :place, :user_id, :address, :date, :kind, :notes, :enrolled, :notificated_about
  belongs_to :user

  validates :number, presence: true, numericality: true
  validate :no_double_tournaments_are_allowed, on: :create

  before_create :fillup_missing_data
  before_destroy :send_mail_if_enrolled_tournament_is_deleted

  delegate :name, to: :user, prefix: true

  def to_s
    "Tournament ##{self.id} - date: #{self.date} - enrolled: #{self.enrolled} - notificated_about: #{self.notificated_about}"
  end

   def no_double_tournaments_are_allowed
     Tournament.where(number: number, user_id: user_id).size == 0
     errors.add(:double, "was allready added") unless Tournament.where(:number => number, :user_id => user_id).size == 0
   end

  def incomplete?
    return self.participants.nil? && self.place.nil?
  end

  def get_date
    self.date.to_datetime
  end

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
    [(participants - place), 20].min
  end

  def start_class
    return self.kind.split(" ")[1]
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
    logger.debug "Tournament#send_mail_if_enrolled_tournament_is_deleted started"

    if self.is_enrolled_and_not_danced?
      club_owners_mailaddresses = self.user.clubs.collect{|x| x.owner}.compact.collect{|x| x.email}
      logger.debug "enrolled tournamentDeleted Mail was send to #{club_owners_mailaddresses.join(', ')}"
      NotificationMailer.enrolledTournamentWasDeleted(club_owners_mailaddresses, self).deliver
    end
    logger.debug "deleted tournament #{self.to_s}"
    logger.debug "Tournament#send_mail_if_enrolled_tournament_is_deleted ended"
  end

  def self.find_by_number(number)
    return nil if number.nil? || number == ""

    agent = Mechanize.new
    agent.get("http://appsrv.tanzsport.de/td/db/turnier/einzel/suche")
    form = agent.page.forms.last
    form.nr = number
    form.submit

    out = {}

    agent.page.search(".veranstaltung").each do |event|
      event.search(".ort a").each do |link|
        url = link.attributes["href"].value
        out[:address] = url.slice(30..url.length)
      end
      @date = event.search(".kategorie").first.text.slice(0..9)
    end

    agent.page.search(".markierung").each do |item|

      if item.search(".uhrzeit").first.text.empty?
        puts "This Tournament seems to be a big one: #{number}"
        item.parent.children.each do |all_tournaments|
          next_kind = all_tournaments.search(".turnier").first.text
          next_time = all_tournaments.search(".uhrzeit").first.text
          next_notes = all_tournaments.search(".bemerkung").first.text

          out[:kind] = next_kind unless next_kind.empty?
          @time = next_time unless next_time.empty?
          out[:notes] = next_notes unless next_notes.empty?

          break if all_tournaments.attributes().has_key?('class')
        end

      else
        out[:kind] = item.search(".turnier").first.text
        @time = item.search(".uhrzeit").first.text
        out[:notes] = item.search(".bemerkung").first.text
      end
    end

    out[:date] = DateTime.parse "#{@time} #{@date}"

    return out
  end


end