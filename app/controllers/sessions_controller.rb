***REMOVED*** This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  ***REMOVED*** Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include CASControllerIncludes

  ***REMOVED*** Don't render new.rhtml; instead, just redirect to dashboard, because  
  ***REMOVED*** we want to prevent people from accessing restful_authentication's 
  ***REMOVED*** user subsystem directly, instead using CAS.
  def new
    redirect_to :controller => "dashboard", :action => "index"
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      ***REMOVED*** Protects against session fixation attacks, causes request forgery
      ***REMOVED*** protection if user resubmits an earlier form using back
      ***REMOVED*** button. Uncomment if you understand the tradeoffs.
      ***REMOVED*** reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default(:controller=>"dashboard", :action=>:index)
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    
     ***REMOVED*** http://wiki.case.edu/Central_Authentication_Service: best practices: only logout app, not CAS

    flash[:notice] = "You have been logged out of ResearchMatch. You're still logged in to CAS, though.. click <a href='***REMOVED***{url_for :action=>:logout_cas}'><b>here</b></a> to logout of CAS."
***REMOVED***    redirect_back_or_default(:controller=>"dashboard", :action=>:index) 
    redirect_to :controller=>:dashboard, :action=>:index
  end

  def logout_cas
    CASClient::Frameworks::Rails::Filter.logout(self, url_for(:controller=>:dashboard, :action=>:index) )
  end

protected
  ***REMOVED*** Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '***REMOVED***{params[:email]}'. Check your email or password."
    logger.warn "Failed login for '***REMOVED***{params[:email]}' from ***REMOVED***{request.remote_ip} at ***REMOVED***{Time.now.utc}"
  end
end
