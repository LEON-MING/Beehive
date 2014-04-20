class DashboardController < ApplicationController
  ***REMOVED*** This filter is probably not necessary because of the CAS authentication stuff.
  ***REMOVED*** Hence, it's commented out:
  ***REMOVED*** before_filter :login_required

  include CASControllerIncludes

  ***REMOVED***CalNet / CAS Authentication
  before_filter :goto_home_unless_logged_in  ***REMOVED***CASClient::Frameworks::Rails::Filter
  ***REMOVED*** before_filter :setup_cas_user
  before_filter :rm_login_required

  def index
      @departments = Department.all
      @recently_added_jobs = Job.find(:all, :conditions => ["status = ?",  0], :order => "created_at DESC", :limit => 5)
      @relevant_jobs = Job.smartmatches_for(@current_user, 4)

      @watched_jobs = @current_user.watched_jobs_list_of_user

      @your_jobs = Job.find(:all, :conditions => [ "user_id = ?", @current_user.id ])
  end
end
