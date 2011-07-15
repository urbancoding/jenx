#
#  JenxConnection.rb
#  jenx
#
#  Created by Trent Kocurek on 5/23/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

class JenxConnection
    def initialize(url)
        @url = url
        self
    end
    
    def is_connected?
        connection_result = JenxConnectionManager.new do
            result = Net::HTTP.get_response(URI.parse(@url)) 
        end
        
        connection_result.value
    end
end