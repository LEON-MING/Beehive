require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :jobs
  has_many :job_inactives
  has_many :reviews
  has_one :picture
  
  has_many :enrollments
  has_many :courses, :through => :enrollments

  ***REMOVED***validates_presence_of     :login
  ***REMOVED***validates_length_of       :login,    :within => 3..40
  ***REMOVED***validates_uniqueness_of   :login
  ***REMOVED***validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 ***REMOVED***r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  ***REMOVED*** Check that the email address is @*.berkeley.edu or @*.lbl.gov
  validates_format_of		:email,	   :with => /^[^@]+@(?:.+\.)?(?:(?:berkeley\.edu)|(?:lbl\.gov))$/i, :message => "The specified email is not a Berkeley or LBL address."

  before_create :make_activation_code 
  before_validation :handle_email
  before_validation :handle_courses
  
  ***REMOVED*** HACK HACK HACK -- how to do attr_accessible from here?
  ***REMOVED*** prevents a user from submitting a crafted form that bypasses activation
  ***REMOVED*** anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation, :faculty_email, :student_email, :is_faculty, :course_names
  attr_reader :faculty_email; attr_writer :faculty_email  
  attr_reader :student_email; attr_writer :student_email
  attr_reader :course_names; attr_writer :course_names
  
  ***REMOVED*** Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  ***REMOVED*** Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    ***REMOVED*** the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  ***REMOVED*** Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  ***REMOVED***
  ***REMOVED*** uff.  this is really an authorization, not authentication routine.  
  ***REMOVED*** We really need a Dispatch Chain here or something.
  ***REMOVED*** This will also let us return a human error message.
  ***REMOVED***
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] ***REMOVED*** need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  ***REMOVED***def login=(value)
  ***REMOVED***  write_attribute :login, (value ? value.downcase : nil)
  ***REMOVED***end

  def email=(value)
    write_attribute :email, (value && !value.empty? ? value.downcase : self.email)
  end
  
  
  ***REMOVED*** Returns a string containing the course names taken by user @user
  ***REMOVED*** e.g. "CS162,CS61A"
  def course_list_of_user
  	course_list = ''
  	courses.each do |course|
  		course_list << course.name + ','
  	end
  	course_list[0..(course_list.length - 2)].upcase
  end

  protected
    

    def make_activation_code
  
      self.activation_code = self.class.make_token
    end

	***REMOVED*** Dynamically assign the value of :email, based on whether this user
	***REMOVED*** is marked as faculty or not. This should occur as a before_validation
	***REMOVED*** since we want to save a value for :email, not :faculty_ or :student_email.
	def handle_email
		self.email = (self.is_faculty ? self.faculty_email : self.student_email)
	end
	
	***REMOVED*** Parses the textbox list of courses from "CS162,CS61A,EE123"
	***REMOVED*** etc. to an enumerable object courses
	def handle_courses
		self.courses = []  ***REMOVED*** eliminates any previous enrollments so as to avoid duplicates
		course_array = []
		course_array = course_names.split(',') if ! course_names.nil?
		puts course_array
		course_array.each do |item|
			self.courses << Course.find_by_name(item.upcase.strip)
		end
	end
	

	
end
