class OrgsController < ApplicationController

  # Only logged in users can view this page
  before_filter :goto_home_unless_logged_in
  before_filter :rm_login_required

  # Only users in the org can modify it
  before_filter :correct_user_access, :only => [:edit, :update, :curate]

  # Only admins can create or delete orgs
  before_filter :require_admin, :only => [:new, :create, :destroy]

  # GET /orgs
  # GET /orgs.json
  def index
    @orgs = Org.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orgs }
    end
  end

  # GET /orgs/1
  # GET /orgs/1.json
  def show
    @org = Org.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @org }
    end
  end

  # GET /orgs/new
  # GET /orgs/new.json
  def new
    @org = Org.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @org }
    end
  end

  # GET /orgs/1/edit
  def edit
    @org = Org.find(params[:id])
  end

  # POST /orgs
  # POST /orgs.json
  def create
    @org = Org.new(params[:org])

    respond_to do |format|
      if @org.save
        format.html { redirect_to @org, notice: 'Org was successfully created.' }
        format.json { render json: @org, status: :created, location: @org }
      else
        format.html { render action: "new" }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orgs/1
  # PUT /orgs/1.json
  def update
    @org = Org.find(params[:id])

    respond_to do |format|
      if @org.update_attributes(params[:org])
        format.html { redirect_to @org, notice: 'Org was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /orgs/1/curate?job_id=2
  def curate
    @org = Org.find(params[:id])
    job = Org.find(params[:job_id])
    curate = Curation.new({:org => @org, :user=> @current_user, :job => job})
    if curate.save
      flash[:notice] = 'Successfully curated listing..'
    else
      flash[:notice] = 'Was not able to curate this listing. Perhaps you\'ve already curated it?'
    end
  end

  # DELETE /orgs/1
  # DELETE /orgs/1.json
  def destroy
    @org = Org.find(params[:id])
    @org.destroy

    respond_to do |format|
      format.html { redirect_to orgs_url }
      format.json { head :no_content }
    end
  end

####################
#     FILTERS      #
####################

  private
  def correct_user_access
    if (Org.find(params[:id]) == nil || (!@current_user.admin? and !Org.find(params[:id]).members.include?(@current_user)))
      flash[:error] = "You don't have permissions to edit or delete that org."
      redirect_to :controller => 'dashboard', :action => :index
    end
  end
end
