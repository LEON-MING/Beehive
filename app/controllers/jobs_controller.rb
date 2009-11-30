class JobsController < ApplicationController
  ***REMOVED*** GET /jobs
  ***REMOVED*** GET /jobs.xml
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_category_name]
  auto_complete_for :category, :name
  
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_course_name]
  auto_complete_for :course, :name
  
  ***REMOVED*** Ensures that only logged-in users can create, edit, or delete jobs
  before_filter :login_required, :except => [ :index, :show, :list ]
  
  def index
    @search_query = "Keyword (leave blank to view all)"
	***REMOVED***@search_query = params[:search_terms][:query]
	***REMOVED***@department = params[:search_terms][:department]
	***REMOVED***@faculty = params[:search_terms][:faculty]
	***REMOVED***@paid = params[:search_terms][:paid]
	***REMOVED***@credit = params[:search_terms][:credit]
	
	***REMOVED***@department ||= 0
	***REMOVED***@faculty ||= 0
	***REMOVED***@paid ||= 0
	***REMOVED***@credit ||= 0
	
    @jobs = Job.find(:all, :conditions => [ "active = ?", true ], :order => "created_at DESC")
	@departments = Department.all
    respond_to do |format|
      format.html ***REMOVED*** index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end
  
  def list
	@search_query = "Keyword (leave blank to view all)"
	d_id = params[:department_select]
	
	params[:search_terms] ||= {}
	query = params[:search_terms][:query]
	department = params[:search_terms][:department_select].to_i
	faculty = params[:search_terms][:faculty_select].to_i
	paid = params[:search_terms][:paid].to_i
	credit = params[:search_terms][:credit].to_i

	if(query && !query.empty? && (query != @search_query))
		@jobs = Job.find_by_solr_by_relevance(query).select { |c| c.active == true } ***REMOVED*** How to filter these results pre-query through solr?  Should actually be filtered through solr, not here.
		@jobs = @jobs.sort {|a,b| a.created_at <=> b.created_at} if false
		
	else
		***REMOVED***flash[:notice] = 'Your query was invalid and could not return any results.'
		@jobs = Job.find(:all, :order=>"created_at DESC", :conditions=> {:active => true})
	end ***REMOVED***end params[:query]

	@jobs = @jobs.select {|j| j.department_id.to_i == department } if department != 0
	@jobs = @jobs.select {|j| j.faculties.collect{|f| f.id.to_i}.include?(faculty) }  if faculty != 0
	@jobs = @jobs.select {|j| j.paid } if paid != 0
	@jobs = @jobs.select {|j| j.credit } if credit != 0
	
	respond_to do |format|
		format.html { render :action => :index }
		format.xml { render :xml => @jobs }
	end
		
  end
    
  ***REMOVED*** GET /jobs/1
  ***REMOVED*** GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html ***REMOVED*** show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  ***REMOVED*** GET /jobs/new
  ***REMOVED*** GET /jobs/new.xml
  def new
    @job = Job.new
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end
	
  end

  ***REMOVED*** GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end

  end

  ***REMOVED*** POST /jobs
  ***REMOVED*** POST /jobs.xml
  def create
	params[:job][:user] = current_user
	
	***REMOVED*** Handles the text_field_with_auto_complete for categories.
	params[:job][:category_names] = params[:category][:name]
	
	***REMOVED*** Handles the text_field_with_auto_complete for required courses.
	params[:job][:course_names] = params[:course][:name]

	params[:job][:active] = false
	
	
	params[:job][:activation_code] = 100
	
	sponsorships = []
	if params[:faculty_name] != ""
		@sponsorship = Sponsorship.new(:faculty => Faculty.find(params[:faculty_name]), :job => nil)
		params[:job][:sponsorships] = sponsorships << @sponsorship
	end
	@job = Job.new(params[:job])
	
    respond_to do |format|
      if @job.save
		***REMOVED***@sponsorship.save
		@job.sponsorships.each { |c| c.job = @job }
		@job.activation_code = (@job.id * 10000000) + (rand(99999) + 100000) ***REMOVED*** Job ID appended to a random 6 digit number.
		@job.save
        flash[:notice] = 'Thank you for submitting a job.  Before this job can be added to our listings page and be viewed by '
		flash[:notice] << 'other users, it must be approved by the faculty sponsor.  An e-mail has been dispatched to the faculty '
		flash[:notice] << 'sponsor with instructions on how to activate this job.  Once activated, users will be able to browse and respond to the job posting.'
		
		***REMOVED*** Send an e-mail to the faculty member(s) involved.
		
		***REMOVED***FacultyMailer.deliver_faculty_confirmer(found_faculty.email, found_faculty.name, @job.id, @job.title, @job.desc, @job.activation_code)
		
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  ***REMOVED*** PUT /jobs/1
  ***REMOVED*** PUT /jobs/1.xml
  def update	
	***REMOVED***params[:job][:sponsorships] = Sponsorship.new(:faculty => Faculty.find(:first, :conditions => [ "name = ?", params[:job][:faculties] ]), :job => nil)	
    @job = Job.find(params[:id])
	
    @all_faculty = Faculty.find(:all)
    @faculty_names = []
    @all_faculty.each do |faculty|
      @faculty_names << faculty.name
    end
	
	sponsorships = []
	if params[:faculty_name] != @job.faculties.first.id
		@sponsorship = Sponsorship.new(:faculty => Faculty.find(params[:faculty_name]), :job => nil)
		params[:job][:sponsorships] = sponsorships << @sponsorship
	end
	
	***REMOVED*** Handles the text_field_with_auto_complete for categories.
	params[:job][:category_names] = params[:category][:name]
	
	***REMOVED*** Handles the text_field_with_auto_complete for required courses.
	params[:job][:course_names] = params[:course][:name]

			
    respond_to do |format|
      if @job.update_attributes(params[:job])
	  	populate_tag_list
		@job.save
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  ***REMOVED*** DELETE /jobs/1
  ***REMOVED*** DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
  
  def activate
    ***REMOVED*** /jobs/activate/job_id?a=xxx
	@job = Job.find(:first, :conditions => [ "activation_code = ? AND active = ?", params[:a], false ])
	
	
	if @job != nil
		populate_tag_list
		
		@job.skip_handle_categories = true
		@job.active = true
		saved = @job.save
	else 
		saved = false
	end
	
	respond_to do |format|
		if saved
		  @job.skip_handle_categories = false
		  flash[:notice] = 'Job activated successfully.  Your job is now available to be browsed and viewed by other users.'
		  format.html { redirect_to(@job) }
		else
		  flash[:notice] = 'Unsuccessful activation.  Either this job has already been activated or the activation code is incorrect.'
		  format.html { redirect_to(jobs_url) }
		end
	end
	
  end
  
  def job_read_more
	job = Job.find(params[:id])
	render :text=> job.desc
  end
  
  def job_read_less
	job = Job.find(params[:id])
	desc = job.desc.first(100)
	desc = desc << "..." if job.desc.length > 100
	render :text=>  desc
  end
  
 
  
  protected
  
  ***REMOVED*** Populates the tag_list of the job.
  def populate_tag_list
	tags_string = ""
	tags_string << @job.category_list_of_job 
	tags_string << ',' + @job.course_list_of_job unless @job.course_list_of_job.empty?
	tags_string << ',' + (@job.paid ? 'paid' : 'unpaid')
	tags_string << ',' + (@job.credit ? 'credit' : 'no credit')
	@job.tag_list = tags_string
  end
  
  
end