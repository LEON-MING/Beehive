***REMOVED*** == Schema Information
***REMOVED***
***REMOVED*** Table name: owns
***REMOVED***
***REMOVED***  id         :integer          not null, primary key
***REMOVED***  job_id     :integer
***REMOVED***  user_id    :integer
***REMOVED***  created_at :datetime
***REMOVED***  updated_at :datetime
***REMOVED***

class Own < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
end
