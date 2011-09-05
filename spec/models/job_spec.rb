require 'spec_helper'

describe Job do

  before(:each) do
    @controller = mock('JobsController')
    @controller.stub!(:login_required).and_return(true)
    @valid_attributes = {
      :title => "value for title",
      :desc => "value for desc",
      :end_date => Time.now + 5.hours,
      :num_positions => 1,
      :paid => false,
      :credit => false,
      :active => true
    }

    @mock_sponsorship ||= stub_model(Sponsorship)
    @mock_department  ||= stub_model(Department)
    @mock_user        ||= stub_model(User)
    @mock_category    ||= stub_model(Category)
  end
  
  ***REMOVED***
  ***REMOVED*** Validation
  ***REMOVED***
  describe "validation:" do

    ***REMOVED***
    ***REMOVED*** Setup
    ***REMOVED***

    before :each do
      @valid_jobs = []
    end

    after :each do
      @valid_jobs.each {|j| j.destroy}
    end

    ***REMOVED***
    ***REMOVED*** Specs
    ***REMOVED***

    it "should create a new instance given valid attributes" do
      create_job.should be_valid
      job = Job.new(@valid_attributes)
      job.sponsorships << mock_model(Sponsorship)
      job.department   =  mock_model(Department)
      job.user         =  mock_model(User)
      job.categories   << mock_model(Category)
      job.valid?
      job.errors.should == {} and job.should be_valid
    end

    describe "title" do
      it "should be between 10 and 200 characters, inclusive" do
        test_range(10..200) do |n, valid|
          Job.new(:title => 'a'*n).errors_on(:title).empty?.should == valid
        end
      end
    end ***REMOVED*** title

    describe "description" do
      it "should be within 10 and 20000 characters" do
        test_range(10..20000) do |n, valid|
          Job.new(:desc => 'a'*n).errors_on(:desc).empty?.should == valid
        end
      end
    end

    describe "num positions" do
      it "should be nonnegative" do
        Job.new(:num_positions => -1).errors_on(:num_positions).should_not be_empty
        Job.new(:num_positions =>  0).errors_on(:num_positions).should     be_empty
        Job.new(:num_positions =>  2).errors_on(:num_positions).should     be_empty
      end

      it "should be optional" do
        Job.new(:num_positions => nil).errors_on(:num_positions).should be_empty
      end
    end

    describe "start dates" do
      before :each do
        @a = Time.now + 1.hour
        @b = @a + 1.day
        @c = @b + 1.week
      end

      it "should be in chronological order" do
        Job.new(:earliest_start_date => @a, :latest_start_date => @b).errors_on(:earliest_start_date).should be_empty
        Job.new(:earliest_start_date => @b, :latest_start_date => @a).errors_on(:earliest_start_date).should_not be_empty
      end

      describe "and end date" do
        it "should be in chronological order" do
          Job.new(:earliest_start_date => @a, :latest_start_date => @b, :end_date => @c).errors_on(:latest_start_date).should be_empty
          Job.new(:earliest_start_date => @b, :latest_start_date => @c, :end_date => @a).errors_on(:latest_start_date).should_not be_empty
        end
      end
    end ***REMOVED*** start dates

    describe "required attributes" do
      it "should include title, desc, department" do
        [ :title, :desc, :department ].each do |attrib|
          Job.new(attrib => nil).errors_on(attrib).should_not be_empty
        end
      end

      it "should include sponsorships" do
        pending
      end
    end ***REMOVED*** required attribs
    
  end ***REMOVED*** validations

  describe "searching" do
    before :each do
      @valid_jobs = []
      create_job({
        :title => "regular job",
        :active => true
      })
      create_job({
        :title => "inactive job",
        :active => false
      })
      create_job({
        :title => "another regular job",
        :active => true
      })
    end

    after :each do
      @valid_jobs.each {|j| j.destroy}
    end

    describe "search with default options" do
      it "should return all active jobs" do
        Job.find_jobs.count.should == @valid_jobs.select{|j| j.active}.count
      end
    end
  end ***REMOVED*** searching
  
protected
  def create_job(attribs={})
    j = Job.new(@valid_attributes.merge(attribs))

    j.sponsorships << @mock_sponsorship
    j.department   =  @mock_department
    j.user         =  @mock_user
    j.categories   << @mock_category

    j.valid?
    j.errors.should == {} and j.should be_valid

    ***REMOVED*** wtf
    @mock_category.should_receive(:record_timestamps)
    @mock_sponsorship.should_receive(:[]=)

    j.save.should == true

    @valid_jobs << j
    yield j if block_given?
    j
  end
end

