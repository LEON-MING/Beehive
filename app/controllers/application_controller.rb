***REMOVED*** Filters added to this controller apply to all controllers in the application.
***REMOVED*** Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all ***REMOVED*** include all helpers, all the time
  include ApplicationHelper
  include CASControllerIncludes
  protect_from_forgery ***REMOVED*** See ActionController::RequestForgeryProtection for details

  before_filter :set_current_user
  before_filter :set_actionmailer_base_url

  ***REMOVED*** rescue_from Exception do |e|
  ***REMOVED***   @exception = e
  ***REMOVED***   render 'common/exception', :status => 500

  ***REMOVED***   Rails.logger.error "ERROR 500: ***REMOVED***{e.inspect}"

  ***REMOVED***   request.env["exception_notifier.exception_data"] = {
  ***REMOVED***     :timestamp => Time.now.to_i
  ***REMOVED***   }

  ***REMOVED***   begin
  ***REMOVED***     ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
  ***REMOVED***   rescue => f
  ***REMOVED***     Rails.logger.error "ExceptionNotifier: Failed to deliver because ***REMOVED***{f.inspect}"
  ***REMOVED***   end
  ***REMOVED***   raise if Rails.test?
  ***REMOVED*** end

  ***REMOVED*** Puts a flash[:notice] error message and redirects if condition isn't true.
  ***REMOVED*** Returns true if redirected.
  ***REMOVED***
  ***REMOVED*** Usage: return if redirected_because(!user_logged_in, "Not logged in!", "/diaf")
  ***REMOVED***
  def redirected_because(condition=true, error_msg="Error!", redirect_url=nil)
    return false if condition == false or redirect_url.nil?
    flash[:error] = error_msg
    redirect_to redirect_url unless redirect_url.nil?
    return true
  end



***REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED***
***REMOVED***     FILTERS      ***REMOVED***
***REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED******REMOVED***

  ***REMOVED*** Only the user to whom the job belongs is permitted to view the particular
  ***REMOVED*** action for this job.
  def view_ok_for_unactivated_job
    j = (Job.find(params[:id].present? ? params[:id] : params[:job_id]) rescue nil)
      ***REMOVED*** id and job_id because this filter is used by both the JobsController
      ***REMOVED*** and the ApplicsController
    if j == nil
      flash[:error] = "Sorry, that project isn't active."
      redirect_to :controller => 'dashboard', :action => :index
    end
  end

  ***REMOVED*** Only users other than the user to whom the job belongs is permitted to watch
  ***REMOVED*** or apply to the job.
  def watch_apply_ok_for_job
    j = Job.find(params[:id].present? ? params[:id] : params[:job_id])
      ***REMOVED*** id and job_id because this filter is used by both the JobsController
      ***REMOVED*** and the ApplicsController
    if (j == nil || @current_user == j.user)
      flash[:error] = "You cannot watch or apply to your own listing."
      redirect_to job_path(j)
    end
  end

  ***REMOVED*** Tests exception notification by raising an uncaught exception.
  def test_exception_notification
    raise NotImplementedError.new("Exceptions aren't implemented yet.")
  end

  private

  def set_actionmailer_base_url
    ActionMailer::Base.default_url_options ||= {}
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def set_current_user
    @user_session = UserSession.find
    @current_user = @user_session ? @user_session.user : nil
  end
  
  def require_admin
    unless logged_in_as_admin?
      redirect_to request.referer || home_path, :notice => "Insufficient privileges"
    end
  end

end
