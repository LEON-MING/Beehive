***REMOVED*** Filters added to this controller apply to all controllers in the application.
***REMOVED*** Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all ***REMOVED*** include all helpers, all the time
  protect_from_forgery ***REMOVED*** See ActionController::RequestForgeryProtection for details
 
  ***REMOVED*** Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  before_filter :current_user_if_logged_in
  
  def current_user_if_logged_in
	  @user = current_user if logged_in?
  end
  
  ***REMOVED*** Puts a flash[:notice] error message and redirects if condition isn't true.
  ***REMOVED*** Returns true if redirected.
  ***REMOVED***
  ***REMOVED*** Usage: return if redirected_because(!user_logged_in, "Not logged in!", "/diaf")
  ***REMOVED***
  def redirected_because(condition=true, error_msg="Error!", redirect_url=nil)
    return false if condition == false or redirect_url.nil?
    flash[:notice] = error_msg
    redirect_to redirect_url unless redirect_url.nil?
    return true
  end
  
end
