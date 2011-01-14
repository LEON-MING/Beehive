require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
***REMOVED***  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  class Types
      Undergrad = 0
      Grad      = 1
      Faculty   = 2
  end
  
  has_many :jobs,        :dependent => :nullify
  has_many :reviews
  has_one  :picture
  has_one  :resume,      :class_name => 'Document', :conditions => {:document_type => Document::Types::Resume}, :dependent => :destroy
  has_one  :transcript,  :class_name => 'Document', :conditions => {:document_type => Document::Types::Transcript}, :dependent => :destroy
  
  has_many :reviews
  has_many :applied_jobs,  :class_name => 'Job', :through => :applics
  has_many :watches,       :dependent => :destroy
  has_many :enrollments,   :dependent => :destroy
  has_many :courses,       :through => :enrollments
  has_many :interests,     :dependent => :destroy
  has_many :categories,    :through => :interests
  has_many :proficiencies, :dependent => :destroy
  has_many :proglangs,     :through => :proficiencies
  

  ***REMOVED***validates_presence_of     :login
  ***REMOVED***validates_length_of       :login,    :within => 3..40
  ***REMOVED***validates_uniqueness_of   :login
  ***REMOVED***validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  validates_presence_of     :name
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :within => 0..100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 ***REMOVED***r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  ***REMOVED*** Check that the email address is @*.berkeley.edu or @*.lbl.gov
  ***REMOVED*** validates_format_of		:email,	   :with => /^[^@]+@(?:.+\.)?(?:(?:berkeley\.edu)|(?:lbl\.gov))$/i, :message => "is not a Berkeley or LBL address."

  ***REMOVED*** Check that user type is valid
  validates_inclusion_of    :user_type, :in => [Types::Undergrad, Types::Grad, Types::Faculty]

  before_create :make_activation_code 
  
  ***REMOVED*** Before carrying out validations (i.e., before actually creating the user object), assign the proper 
  ***REMOVED*** email address to the user (depending on whether the user is a student or gsi or a faculty) 
  ***REMOVED*** and handle the courses for the user.
  ***REMOVED*** before_validation :handle_email       ***REMOVED*** Handled by CAS
  ***REMOVED*** before_validation :handle_name        ***REMOVED*** Handled by LDAP
  before_validation :handle_courses
  before_validation :handle_categories
  before_validation :handle_proglangs
  
  ***REMOVED*** HACK HACK HACK -- how to do attr_accessible from here?
  ***REMOVED*** prevents a user from submitting a crafted form that bypasses activation
  ***REMOVED*** anything else you want your user to change should be added here.
  attr_accessible :email, :login, :name,
                  ***REMOVED*** :password, :password_confirmation,
                  ***REMOVED*** :faculty_email, :student_email,
                  ***REMOVED*** :is_faculty,
                  :course_names, :category_names, :proglang_names
                  ***REMOVED*** :student_name, :faculty_name 
  ***REMOVED*** attr_reader :faculty_email; attr_writer :faculty_email  
  ***REMOVED*** attr_reader :student_email; attr_writer :student_email
  attr_reader :course_names; attr_writer :course_names
  attr_reader :proglang_names; attr_writer :proglang_names
  attr_reader :category_names; attr_writer :category_names
  ***REMOVED*** attr_reader :student_name; attr_writer :student_name
  ***REMOVED*** attr_reader :faculty_name; attr_writer :faculty_name
  
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

  ***REMOVED*** Return the user corresponding to given login
  def self.authenticate_by_login(loggin)
    ***REMOVED*** Return user corresponding to login, or nil if there isn't one
    User.find_by_login(loggin)
  end

  ***REMOVED*** Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  ***REMOVED***
  ***REMOVED*** what is this
  ***REMOVED*** |
  ***REMOVED*** v
  ***REMOVED*** uff.  this is really an authorization, not authentication routine.  
  ***REMOVED*** We really need a Dispatch Chain here or something.
  ***REMOVED*** This will also let us return a human error message.
  ***REMOVED***
  ***REMOVED*** *** Password authentication is deprecated
  ***REMOVED***
***REMOVED***  def self.authenticate_by_password(email, password)
***REMOVED***    ***REMOVED*** Since we authenticate with CAS, the existence of a valid CAS session is enough.
***REMOVED***    session[:cas_user].present?
***REMOVED***
***REMOVED***    return nil if email.blank? || password.blank?
***REMOVED***    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] ***REMOVED*** need to get the salt
***REMOVED***    u && u.authenticated?(password) ? u : nil
***REMOVED***  end

  ***REMOVED***def login=(value)
  ***REMOVED***  write_attribute :login, (value ? value.downcase : nil)
  ***REMOVED***end

  def email=(value)
    write_attribute :email, (value && !value.empty? ? value.downcase : self.email)
  end
  
  
  ***REMOVED*** Returns a string containing the 'required course' names taken by this User
  ***REMOVED*** e.g. "CS61A,CS61B"
  def course_list_of_user(add_spaces = false)
  	course_list = ''
  	courses.each do |c|
  		course_list << c.name + ','
  		if add_spaces: course_list << ' ' end
  	end
  	
  	if add_spaces
  	  return course_list[0..(course_list.length - 3)].upcase
	  else
    	return course_list[0..(course_list.length - 2)].upcase
  	end
  end

  ***REMOVED*** Returns a string containing the category names taken by this User
  ***REMOVED*** e.g. "robotics,signal processing"
  def category_list_of_user(add_spaces = false)
  	category_list = ''
  	categories.each do |cat|
  		category_list << cat.name + ','
  		if add_spaces: category_list << ' ' end
  	end
  	
  	if add_spaces
  	  return category_list[0..(category_list.length - 3)].downcase
	  else
    	return category_list[0..(category_list.length - 2)].downcase
  	end
  end
  
  ***REMOVED*** Returns a string containing the 'desired proglang' names taken by this User
  ***REMOVED*** e.g. "java,scheme,c++"
  def proglang_list_of_user(add_spaces = false)
  	proglang_list = ''
  	proglangs.each do |pl|
  		proglang_list << pl.name.capitalize + ','
   		if add_spaces: proglang_list << ' ' end
  	end
  	
  	if add_spaces
  	  return proglang_list[0..(proglang_list.length - 3)]
	  else
    	return proglang_list[0..(proglang_list.length - 2)]
  	end
  end
  
  ***REMOVED*** Returns an array of this user's watched jobs
  def watched_jobs_list_of_user
    jobs = []
    self.watches.all.each do |w|
        this_job = Job.find_by_id(w.job_id)
        if this_job then
            jobs << this_job
        else
            w.destroy
        end
    end
    jobs
    ***REMOVED***@watched_jobs = current_user.watches.map{|w| w.job }
  end
  
  
  ***REMOVED*** is_faculty for backward compatibility
  def is_faculty
    self.user_type == User::Types::Faculty
  end
  
  def can_post?
    [User::Types::Grad, User::Types::Faculty].include? self.user_type
  end


  ***REMOVED*** Returns the UCB::LDAP::Person for this User
  def ldap_person
    @person ||= UCB::LDAP::Person.find_by_uid(self.login) if self.login
  end

  def ldap_person_full_name
    "***REMOVED***{self.ldap_person.firstname} ***REMOVED***{self.ldap_person.lastname}".titleize
  end


  ***REMOVED*** Updates (but does *NOT* save, by default) this User's role, based on the
  ***REMOVED*** LDAP information. Raises an error if the user type can't be determined.
  ***REMOVED***
  ***REMOVED*** Options:
  ***REMOVED***  - save|update: If true, DO update user type in the database.
  ***REMOVED***
  def update_user_type(options={})
    person = self.ldap_person

    case
      when (person.employee_academic? and not person.employee_expired?)
        self.user_type = User::Types::Faculty
      when (person.student? and person.student_registered?)
        case person.berkeleyEduStuUGCode
          when 'G'
            self.user_type = User::Types::Grad
          when 'U' 
            self.user_type = User::Types::Undergrad
          else
            logger.error "User.update_user_type: Couldn't determine student type for login ***REMOVED***{self.login}"
            raise StandardError, "berkeleyEduStuUGCode not accessible. Have you authenticated with LDAP?"
        end ***REMOVED*** under/grad
      else
        logger.error "User.update_user_type: Couldn't determine user type for login ***REMOVED***{self.login}"
        raise StandardError, "couldn't determine user type for login ***REMOVED***{self.login}"
      end ***REMOVED*** employee/student

    self.update_attribute(:user_type, self.user_type) if options[:save] or options[:update]
    self.user_type
  end

  def is_faculty?
    user_type == User::Types::Faculty
  end
  def is_grad?
    user_type == User::Types::Grad
  end
  def is_undergrad?
    user_type == User::Types::Undergrad
  end

  ***REMOVED*** User type, as a string
  ***REMOVED*** TODO: there's probably a better way to do this programmatically
  def user_type_string(options={})
    options[:long] ||= false
    s = ''

    case self.user_type
    when User::Types::Faculty
      s = 'Faculty'
      s += ' member' if options[:long]
    when User::Types::Grad
      s = 'Grad student/postdoc'
    when User::Types::Undergrad
      s = 'Undergrad'
      s += 'uate' if options[:long]
    else
      s = '(undefined)'
      logger.warn "Couldn't find user type string for user type ***REMOVED***{self.user_type}"
    end
    s
  end
  
  protected
    

    def make_activation_code
  
      self.activation_code = self.class.make_token
    end

    ***REMOVED*** Dynamically assign the value of :email, based on whether this user
    ***REMOVED*** is marked as faculty or not. This should occur as a before_validation
    ***REMOVED*** since we want to save a value for :email, not :faculty_email or :student_email.
    def handle_email
      self.email = (self.is_faculty ? Faculty.find_by_name(self.faculty_name).email : self.student_email)
    end
    
    ***REMOVED*** Dynamically assign the value of :name, based on whether this user
    ***REMOVED*** is marked as faculty or not. This should occur as a before_validation
    ***REMOVED*** since we want to save a value for :name, not :faculty_name or :student_name.
    def handle_name
      if self.name.nil? || self.name == ""
              self.name = is_faculty ? faculty_name : student_name
      end
    end

    ***REMOVED*** Parses the textbox list of courses from "CS162,CS61A,EE123"
    ***REMOVED*** etc. to an enumerable object courses
    def handle_courses
      return if self.is_faculty?
      self.courses = []  ***REMOVED*** eliminates any previous enrollments so as to avoid duplicates
      course_array = []
      course_array = course_names.split(',').uniq if ! course_names.nil?
      course_array.each do |item|
              self.courses << Course.find_or_create_by_name(item.upcase.strip)
      end
    end
    
    ***REMOVED*** Parses the textbox list of categories from "signal processing,robotics"
    ***REMOVED*** etc. to an enumerable object categories
    def handle_categories
      return if self.is_faculty?
      self.categories = []  ***REMOVED*** eliminates any previous interests so as to avoid duplicates
      category_array = []
      category_array = category_names.split(',').uniq if ! category_names.nil?
      category_array.each do |cat|
              self.categories << Category.find_or_create_by_name(cat.downcase.strip)
      end
    end
    
    ***REMOVED*** Parses the textbox list of proglangs from "c++,python"
    ***REMOVED*** etc. to an enumerable object proglangs
    def handle_proglangs
      return if self.is_faculty?
      self.proglangs = []  ***REMOVED*** eliminates any previous proficiencies so as to avoid duplicates
      proglang_array = []
      proglang_array = proglang_names.split(',').uniq if ! proglang_names.nil?
      proglang_array.each do |pl|
              self.proglangs << Proglang.find_or_create_by_name(pl.downcase.strip)
      end
    end	
end
