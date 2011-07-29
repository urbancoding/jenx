#
#  JenxConnection.rb
#  jenx
#
#  Created by Trent Kocurek on 5/23/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

class JenxConnection
    def initialize(url, username, password)
        @url = url
        @username = username
        @password = password
        self
    end

    def auth(req)
        req.basic_auth @username, @password unless @username.nil?
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
            req = Net::HTTP::Get.new(JENX_API_URI)
            auth(req)
            response = http.request(req)
            result = response.body
            JSON.parse(result)
        end
        connection_result.value
    end

    def is_connected?
        connection_result = JenxConnectionManager.new do
            uri = URI.parse(@url)
            http = Net::HTTP.new(uri.host, uri.port)
            initSSL(http, uri.scheme)
            req = Net::HTTP::Head.new(JENX_API_URI)
            result = http.request(req)
        end
        connection_result.value
    end
end