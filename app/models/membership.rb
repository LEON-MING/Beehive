class Membership < ActiveRecord::Base

  ***REMOVED*** === List of columns ===
  ***REMOVED***   id         : integer 
  ***REMOVED***   org_id     : integer 
  ***REMOVED***   user_id    : integer 
  ***REMOVED***   created_at : datetime 
  ***REMOVED***   updated_at : datetime 
  ***REMOVED*** =======================

  belongs_to :org
  belongs_to :user
  ***REMOVED*** attr_accessible :title, :body
end