#
#  JenxConnection.rb
#  jenx
#
#  Created by Trent Kocurek on 5/23/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

JENX_API_URL = '/api/json'

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
        connection_result = JenxConnectionManager.new do
            uri = URI.parse(@url)
            http = Net::HTTP.new(uri.host, uri.port)
            initSSL(http, uri.scheme)
            req = Net::HTTP::Get.new(uri.request_uri)
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
            req = Net::HTTP::Head.new(uri.request_uri)
            auth(req)
            response = http.request(req)
            response.code_type == Net::HTTPOK
        end
        connection_result.value
    end
end
