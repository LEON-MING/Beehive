module <%= model_controller_class_name %>Helper
  
  ***REMOVED***
  ***REMOVED*** Use this to wrap view elements that the user can't access.
  ***REMOVED*** !! Note: this is an *interface*, not *security* feature !!
  ***REMOVED*** You need to do all access control at the controller level.
  ***REMOVED***
  ***REMOVED*** Example:
  ***REMOVED*** <%%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  ***REMOVED*** <%%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  ***REMOVED*** <%%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %> 
  ***REMOVED***
  ***REMOVED***
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  ***REMOVED***
  ***REMOVED*** Link to user's page ('<%= table_name %>/1')
  ***REMOVED***
  ***REMOVED*** By default, their login is used as link text and link title (tooltip)
  ***REMOVED***
  ***REMOVED*** Takes options
  ***REMOVED*** * :content_text => 'Content text in place of <%= file_name %>.login', escaped with
  ***REMOVED***   the standard h() function.
  ***REMOVED*** * :content_method => :<%= file_name %>_instance_method_to_call_for_content_text
  ***REMOVED*** * :title_method => :<%= file_name %>_instance_method_to_call_for_title_attribute
  ***REMOVED*** * as well as link_to()'s standard options
  ***REMOVED***
  ***REMOVED*** Examples:
  ***REMOVED***   link_to_<%= file_name %> @<%= file_name %>
  ***REMOVED***   ***REMOVED*** => <a href="/<%= table_name %>/3" title="barmy">barmy</a>
  ***REMOVED***
  ***REMOVED***   ***REMOVED*** if you've added a .name attribute:
  ***REMOVED***  content_tag :span, :class => :vcard do
  ***REMOVED***    (link_to_<%= file_name %> <%= file_name %>, :class => 'fn n', :title_method => :login, :content_method => :name) +
  ***REMOVED***          ': ' + (content_tag :span, <%= file_name %>.email, :class => 'email')
  ***REMOVED***   end
  ***REMOVED***   ***REMOVED*** => <span class="vcard"><a href="/<%= table_name %>/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  ***REMOVED***
  ***REMOVED***   link_to_<%= file_name %> @<%= file_name %>, :content_text => 'Your user page'
  ***REMOVED***   ***REMOVED*** => <a href="/<%= table_name %>/3" title="barmy" class="nickname">Your user page</a>
  ***REMOVED***
  def link_to_<%= file_name %>(<%= file_name %>, options={})
    raise "Invalid <%= file_name %>" unless <%= file_name %>
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= <%= file_name %>.send(options.delete(:content_method))
    options[:title] ||= <%= file_name %>.send(options.delete(:title_method))
    link_to h(content_text), <%= model_controller_routing_name.singularize %>_path(<%= file_name %>), options
  end

  ***REMOVED***
  ***REMOVED*** Link to login page using remote ip address as link content
  ***REMOVED***
  ***REMOVED*** The :title (and thus, tooltip) is set to the IP address 
  ***REMOVED***
  ***REMOVED*** Examples:
  ***REMOVED***   link_to_login_with_IP
  ***REMOVED***   ***REMOVED*** => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  ***REMOVED***
  ***REMOVED***   link_to_login_with_IP :content_text => 'not signed in'
  ***REMOVED***   ***REMOVED*** => <a href="/login" title="169.69.69.69">not signed in</a>
  ***REMOVED***
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  ***REMOVED***
  ***REMOVED*** Link to the current user's page (using link_to_<%= file_name %>) or to the login page
  ***REMOVED*** (using link_to_login_with_IP).
  ***REMOVED***
  def link_to_current_<%= file_name %>(options={})
    if current_<%= file_name %>
      link_to_<%= file_name %> current_<%= file_name %>, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      ***REMOVED*** kill ignored options from link_to_<%= file_name %>
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end

end
