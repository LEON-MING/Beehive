***REMOVED*** == Schema Information
***REMOVED***
***REMOVED*** Table name: applics
***REMOVED***
***REMOVED***  id            :integer          not null, primary key
***REMOVED***  job_id        :integer
***REMOVED***  user_id       :integer
***REMOVED***  created_at    :datetime
***REMOVED***  updated_at    :datetime
***REMOVED***  message       :text
***REMOVED***  resume_id     :integer
***REMOVED***  transcript_id :integer
***REMOVED***  status        :string(255)      default("undecided")
***REMOVED***  applied       :boolean
***REMOVED***

class Applic < ActiveRecord::Base


  belongs_to :job
  belongs_to :user
  validates_presence_of   :message
  validates_length_of     :message, :minimum => 1, :too_short => 'Please enter a message to the faculty sponsor of this listing.'
  validates_length_of     :message, :maximum => 65536, :too_long => 'Please enter a message to the faculty sponsor of this listing that is shorter than 65536 characters.'

  ***REMOVED*** Uniq'd list of emails of all [sponsors, poster] who want to receive notifications for this applic
  def subscriber_emails
    ***REMOVED*** TODO: for now, just email the poster
    job.user.email

    ***REMOVED*** TODO: add preferences to these people
    ***REMOVED*** TODO: condense faculty -> users
***REMOVED******REMOVED***    emales = job.faculties.collect(&:email)
***REMOVED******REMOVED***    emales << user.email
***REMOVED******REMOVED***    emales
  end

  def unread?
    return false
  end

end
