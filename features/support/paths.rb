module NavigationHelpers
  ***REMOVED*** Maps a name to a path. Used by the
  ***REMOVED***
  ***REMOVED***   When /^I go to (.+)$/ do |page_name|
  ***REMOVED***
  ***REMOVED*** step definition in webrat_steps.rb
  ***REMOVED***
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    
    ***REMOVED*** Add more mappings here.
    ***REMOVED*** Here is a more fancy example:
    ***REMOVED***
    ***REMOVED***   when /^(.*)'s profile page$/i
    ***REMOVED***     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"***REMOVED***{page_name}\" to a path.\n" +
        "Now, go and add a mapping in ***REMOVED***{__FILE__}"
    end
  end
end

World(NavigationHelpers)
