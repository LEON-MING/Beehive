class UsersController < ApplicationController
  include AttribsHelper
  include CASControllerIncludes
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_course_name, 
		:auto_complete_for_category_name, :auto_complete_for_proglang_name]
  auto_complete_for :course, :name
  auto_complete_for :category, :name
  auto_complete_for :proglang, :name
    
  ***REMOVED***CalNet / CAS Authentication
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :rm_login_required, :except => [:new, :create]
  ***REMOVED***before_filter :setup_cas_user, :except => [:new, :create]
   
  ***REMOVED*** Ensures that only this user -- and no other users -- can edit his/her profile
  before_filter :correct_user_access, :only => [ :edit, :update, :destroy ]
  
  def show 
    redirect_to :controller => :dashboard, :action => :index unless params[:id].to_s == current_user.id.to_s
  end
  
  ***REMOVED*** Don't render new.rhtml; instead, create the user immediately 
  ***REMOVED*** and redirect to the edit profile page.
  def new
      ***REMOVED*** Make sure user isn't already signed up
      if User.exists?(:login => session[:cas_user]) then
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

    ***REMOVED*** Handles the text_field_with_auto_complete for courses, categories, and programming languages.
    params[:user][:course_names] = params[:course][:name] if params[:course]
    params[:user][:category_names] = params[:category][:name] if params[:category]
    params[:user][:proglang_names] = params[:proglang][:name] if params[:proglang]
    
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
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
      ***REMOVED*** format.html { render :action => 'new' }
      ***REMOVED*** redirect_to new_user_path
      redirect_to :controller => "dashboard", :action => "index"
    end
  end
  
  def edit
    @user = User.find(params[:id])

    prepare_attribs_in_params(@user)
    puts "EDIT:" +  params.inspect
    ***REMOVED*** Ruby magic
    ***REMOVED*** This saves the form data, in the event you tried to update but failed a validation
    ***REMOVED***[:course, :category, :proglang].each do |list|
    ***REMOVED***  params[list.to_s] ||= {:name=>@user.send("***REMOVED***{list}_list_of_user".to_sym, true)}
    ***REMOVED***end

  end
  
  def update
    @user = User.find(params[:id])
    
    ***REMOVED*** If params[:user] is blank? for some reason, instantiate it.
    params[:user] ||= {}
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        @user.update_attribs(params)
        puts "UPDATE: " + params.inspect
        flash[:notice] = 'User profile was successfully updated.'
        format.html { render :action => :edit }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
	
  def correct_user_access
    if (User.find_by_id(params[:id]) == nil || current_user != User.find_by_id(params[:id]))
      ***REMOVED*** flash[:error] = "params[:id] is " + params[:id] + "<br />"
      ***REMOVED*** flash[:error] = "current_user is " + @current_user + "<br />"
      flash[:error] += "Unauthorized access denied. Do not pass Go. Do not collect $200."
            redirect_to :controller => 'dashboard', :action => :index
    end
  end

end
