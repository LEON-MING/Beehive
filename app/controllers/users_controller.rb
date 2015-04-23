class UsersController < ApplicationController
  include AttribsHelper
  include CASControllerIncludes

  ***REMOVED*** skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_course_name,
  ***REMOVED***   :auto_complete_for_category_name, :auto_complete_for_proglang_name]
  ***REMOVED*** auto_complete_for :course, :name
  ***REMOVED*** auto_complete_for :category, :name
  ***REMOVED*** auto_complete_for :proglang, :name

  ***REMOVED***CalNet / CAS Authentication
  ***REMOVED***before_filter CASClient::Frameworks::Rails::Filter
  before_filter :goto_home_unless_logged_in
  before_filter :rm_login_required, :except => [:new, :create]
  ***REMOVED***before_filter :setup_cas_user, :except => [:new, :create]

  ***REMOVED*** Ensures that only this user -- and no other users -- can edit his/her profile
  before_filter :correct_user_access, :only => [ :edit, :update ]

  def show
    @user = User.find_by_id(params[:id])
    @year = @user.year.nil? ? "N/A" : "***REMOVED***{@user.year.ordinalize} year"
  end 

  ***REMOVED*** Don't render new.rhtml; instead, create the user immediately
  ***REMOVED*** and redirect to the edit profile page.
  def new
      ***REMOVED*** Make sure user isn't already signed up
      if User.exists?(:id => session[:user_id]) then
        flash[:warning] = "You're already signed up."
        redirect_to dashboard_path
        return
      end

      @user = User.new(:login => session[:cas_user].to_s)
      person = @user.ldap_person

      if person.nil?
        ***REMOVED*** TODO: what to do here?
        logger.warn "UsersController.new: Failed to find LDAP::Person for uid ***REMOVED***{session[:cas_user]}"
        flash[:error] = "A directory error occurred. Please make sure you've authenticated with CalNet and try again."
        redirect_to '/'
      end

      @user.name  = @user.ldap_person_full_name
      @user.email = person.email
      @user.update_user_type

      ***REMOVED*** create
      create
  end

  def create
    logout_keeping_session!

    ***REMOVED*** See if this user was already created
    ***REMOVED*** TODO: handle this better
    if User.exists?(:login=>session[:cas_user].to_s) then
      flash[:error] = "You've already signed up."
      redirect_to '/'
    end

    @user = User.new(params[:user])
    @user.login = session[:cas_user]
    @user.name = @user.ldap_person_full_name

    ***REMOVED*** For some reason, the email doesn't persist when coming from
    ***REMOVED*** the new action. This band-aid works.
    @user.email ||= @user.ldap_person.email

    @user.update_user_type
    if @user.save && @user.errors.empty? then
      flash[:notice] = "Thanks for signing up! You're activated so go ahead and sign in."
      redirect_to :controller => "jobs", :action => "index"

    else
      logger.error "UsersController.create: Failed because ***REMOVED***{@user.errors.inspect}"
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
      ***REMOVED*** format.html { render :action => 'new' }
      ***REMOVED*** redirect_to new_user_path
      redirect_to :controller => "dashboard", :action => "index"
    end
  end

  def edit
    @user = User.find(params[:id])
    prepare_attribs_in_params(@user)
  end

  def profile
    @user = @current_user
    prepare_attribs_in_params(@current_user)
    render :edit
  end

  def update
    if @current_user.apply?
      @current_user.handle_courses(params[:course][:name])
      @current_user.handle_proglangs(params[:proglang][:name])
      @current_user.handle_categories(params[:category][:name])
    end
    respond_to do |format|
      if @current_user.update_attributes(params[:user])
        flash[:notice] = 'User profile was successfully updated.'
        format.html { redirect_to dashboard_path, notice: 'User profile was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @current_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @users = User.order(:name).page(params[:page])
  end

  private

  def correct_user_access
    if (User.find_by_id(params[:id]) == nil || @current_user != User.find_by_id(params[:id]))
      ***REMOVED*** flash[:error] = "params[:id] is " + params[:id] + "<br />"
      ***REMOVED*** flash[:error] = "@current_user is " + @current_user + "<br />"
      flash[:error] = "You don't have permission to access that."
            redirect_to :controller => 'dashboard', :action => :index
    end
  end
end
