***REMOVED*** The ASF licenses this file to You under the Apache License, Version 2.0
***REMOVED*** (the "License"); you may not use this file except in compliance with
***REMOVED*** the License.  You may obtain a copy of the License at
***REMOVED***
***REMOVED***     http://www.apache.org/licenses/LICENSE-2.0
***REMOVED***
***REMOVED*** Unless required by applicable law or agreed to in writing, software
***REMOVED*** distributed under the License is distributed on an "AS IS" BASIS,
***REMOVED*** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
***REMOVED*** See the License for the specific language governing permissions and
***REMOVED*** limitations under the License.

***REMOVED*** TODO: Consider something lazy like this?
***REMOVED*** Solr::Request::Ping = Solr::Request.simple_request :format=>:xml, :handler=>'admin/ping'
***REMOVED*** class Solr::Request
***REMOVED***   def self.simple_request(options)
***REMOVED***     Class.new do 
***REMOVED***       def response_format
***REMOVED***         options[:format]
***REMOVED***       end
***REMOVED***       def handler
***REMOVED***         options[:handler]
***REMOVED***       end
***REMOVED***     end
***REMOVED***   end
***REMOVED*** end

class Solr::Request::Ping < Solr::Request::Base
  def response_format
    :xml
  end
  
  def handler
    'admin/ping'
  end
end
