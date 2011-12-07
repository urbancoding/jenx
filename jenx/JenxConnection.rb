#
#  JenxConnection.rb
#  jenx
#
#  Created by Trent Kocurek on 5/23/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

class JenxConnection
    def initialize(url, username = nil, password = nil)
        @url = url
        @username = username
        @password = password
        self
    end

    def auth(req)
        req.basic_auth @username, @password unless @username.nil? or @username.empty?
    end

    def initSSL(http, scheme)
        if scheme == "https" then
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
    end

    def all_projects
        uri = URI.parse(@url)
        
        if !uri.respond_to?(:request_uri) then
            NSLog("Failed to load list of projects from @url = \"#{@url}\"")
            return {'jobs' => []}
        end
        
        connection_result = JenxConnectionManager.new do
            http = Net::HTTP.new(uri.host, uri.port)
            initSSL(http, uri.scheme)
            req = Net::HTTP::Get.new(uri.request_uri + JENX_API_URI)
            auth(req)
            response = http.request(req)
            if response.code_type == Net::HTTPOK then
                result = response.body
                JSON.parse(result)
            end
        end
        connection_result.value
    end

    def is_connected?
        connection_result = JenxConnectionManager.new do
            uri = URI.parse(@url)
            http = Net::HTTP.new(uri.host, uri.port)
            initSSL(http, uri.scheme)
            req = Net::HTTP::Head.new(uri.request_uri + JENX_API_URI)
            auth(req)
            response = http.request(req)
            response.code_type == Net::HTTPOK
        end
        connection_result.value
    end
end
