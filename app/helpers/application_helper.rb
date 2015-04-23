***REMOVED*** Methods added to this helper will be available to all templates in the application.
include JobsHelper

module ApplicationHelper
  include TagsHelper

  module NonEmpty
      def nonempty?
          not self.nil? and not self.empty?
      end
  end

  ***REMOVED*** Checks if user is logged in as an admin.
  ***REMOVED*** @return [Boolean] true if {***REMOVED***current_user} is set and is {User***REMOVED***admin?}
  def logged_in_as_admin?
    @current_user and @current_user.admin?
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  def email_regex
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end

  def can_view_apps(current_user, job)
    current_user.present? && (job.contacter == current_user || 
                              job.sponsorships.include?(current_user) ||
                              job.owners.include?(current_user) ||
                              job.faculties.include?(current_user))
  end
end

module ActionView
  module Helpers
    def tag_search_path(tagstring)
      "***REMOVED***{jobs_path}?tags=***REMOVED***{tagstring}"
    end

    ThreeStateLabels = {true=>'Yes', false=>'No', nil=>'N/A'}

    module FormTagHelper
      def indeterminate_check_box_tag(name, value = "1", indeterminate_value = "2", checked = :unchecked, options = {})
        onclick = "this.value=(Number(this.value)+1)%3;this.checked=(this.value==1);this.indeterminate=(this.value==2);"
        check_box_tag(name, value, checked, options.merge({:onclick=>onclick}))
      end


      ***REMOVED*** Select box that maps {true=>1, false=>0, nil=>2}
      def three_state_select_tag(name, value=nil, options={})
        labels = options.delete(:labels) || ThreeStateLabels
        values = options.delete(:values) || {true=>1, false=>0, nil=>2}
        select_tag name, options_for_select([true,false,nil].collect{|k|[labels[k],values[k]]},values[value]), options
      end
    end
  end
end

class String
    include ApplicationHelper::NonEmpty

    ***REMOVED*** Translates \n line breaks to <br />'s.
    def to_br
        self.gsub("\n", "<br />")
    end

    def pluralize_for(n=1)
      n == 1 ? self : self.pluralize
    end

end

class Array
    include ApplicationHelper::NonEmpty
end

class NilClass
    include ApplicationHelper::NonEmpty
end

class Time
    def pp
        self.getlocal.strftime("%b %d, %Y")
    end
end



***REMOVED*** Finds value in find_from, and returns the corresponding item from choose_from,
***REMOVED*** or default (nil) if find_from does not contain the value.
***REMOVED*** Comparisons are done using == and then eql? .
***REMOVED***
***REMOVED*** Ex. find_and_choose(["apples", "oranges"], [:red, :orange], "apples")
***REMOVED***        would return :red.
***REMOVED***
def find_and_choose(find_from=[], choose_from=[], value=nil, default=nil)
  find_from.each_index do |i|
      puts "\n\nchecking ***REMOVED***{value} == ***REMOVED***{find_from[i]}\n"
      return choose_from[i] if find_from[i] == value || find_from[i].eql?(value)
      puts "\n\n\n***REMOVED***{value} wasn't ***REMOVED***{find_from[i]}\n\n\n"
  end
  return default
end


***REMOVED*** Amazing logic that returns correct booleans.
***REMOVED***
***REMOVED***        n   |  output
***REMOVED***      ------+----------
***REMOVED***        0   |  false
***REMOVED***        1   |  true
***REMOVED***      false |  false
***REMOVED***      true  |  true
***REMOVED***
def from_binary(n)
***REMOVED***      puts "\n\n***REMOVED***{n} => ***REMOVED***{n && n!=0}\n\n"
  n && n!=0
end



module CASControllerIncludes
  def goto_home_unless_logged_in
    ***REMOVED***CASClient::Frameworks::Rails::Filter.filter(self) unless @current_user && @user_session
    return true if @current_user && @user_session
    (redirect_to home_path) and false
  end

  def login_user!(user)
    return UserSession.new(user).save
  end

  def rm_login_required
    return true if @current_user
    (redirect_to login_path) and false
  end

  def first_login(auth_field, auth_value)
  ***REMOVED*** Processes a user's first login, which involves creating a new User.
  ***REMOVED*** Requires a CAS session to be present, and redirects if it isn't.
  ***REMOVED*** @returns false if redirected because of new user processing, true if user was already signed up
  ***REMOVED***
    
    ***REMOVED*** Require CAS login first
    unless @user_session
      (redirect_to login_path) and false
    end

    ***REMOVED*** If user doesn't exist, create it. Use current_user
    ***REMOVED*** so as to ensure that redirects work properly; i.e.
    ***REMOVED*** so that you are 'logged in' when you go to the Edit Profile
    ***REMOVED*** page in this next section here.

    unless User.exists?(auth_field => auth_value)
      new_user = User.new
      new_user[auth_field] = auth_value

      ***REMOVED*** Implement separate auth provider logic here
      if session[:auth_hash][:provider].to_sym == :cas
        ***REMOVED*** When using CAS, the Users table is populated from LDAP
        person = new_user.ldap_person
        if person
          new_user.email = person.email
          new_user.name = new_user.ldap_person_full_name
          new_user.update_user_type
        end
      end

      if new_user.save && new_user.errors.empty?
        flash[:notice] = "Welcome to Beehive! Since this is your first time here, "
        flash[:notice] << "please make sure you update your email address. We'll send all correspondence to that email address."
        logger.info "First login for ***REMOVED***{new_user.login}"

        @current_user = User.where(auth_field => auth_value)[0]
        session[:user_id] = @current_user.id
        redirect_to edit_user_path(@current_user.id)
        return false
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
        flash[:error] += new_user.errors.inspect if Rails.env == 'development'
        redirect_to home_path
        return false
      end
    end

    logger.info('LOGIN') if Rails.env == 'development'
    return true
  end

  ***REMOVED*** Redirects to signup page if user hasn't registered.
  ***REMOVED*** Filter fails if no auth hash is present, or if user was redirected to
  ***REMOVED*** signup page.
  ***REMOVED*** Filter passes if auth hash is present, and a user exists.
  def require_signed_up
    return true if session[:auth_hash].present? && User.find(session[:user_id])
    (redirect_to :controller => :users, :action => :new) and false
  end
end
