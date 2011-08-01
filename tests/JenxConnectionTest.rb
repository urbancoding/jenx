#
#  JenxConnectionTest.rb
#  jenx
#
#  Created by Roman Dmytrenko.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

class JenxConnectionTest < JenxTestCase

    def test_should_auth_if_username_provided
        connection = JenxConnection.new('http://fake.jenkins', 'user', 'password')
        req = Net::HTTP::Head.new(JENX_API_URI)
        connection.auth(req)
        headers = req.to_hash
        assert_equal headers['authorization'], ['Basic dXNlcjpwYXNzd29yZA==']
    end

    def test_should_not_auth_if_username_is_nil
        connection = JenxConnection.new('http://fake.jenkins')
        req = Net::HTTP::Head.new(JENX_API_URI)
        connection.auth(req)
        headers = req.to_hash
        assert_nil headers['authorization']
    end

    def test_should_not_auth_if_username_is_empty_string
        connection = JenxConnection.new('http://fake.jenkins', '', '')
        req = Net::HTTP::Head.new(JENX_API_URI)
        connection.auth(req)
        headers = req.to_hash
        assert_nil headers['authorization']
    end

    def test_should_use_ssl_if_url_is_secure
        connection = JenxConnection.new('https://fake.jenkins')
        uri = URI.parse('https://fake.jenkins')
        http = Net::HTTP.new(uri.host, uri.port)
        connection.initSSL(http, uri.scheme)
        assert http.use_ssl?
    end

    def test_should_connect_successfully
        url = 'http://user:pass@fake.jenkins/api/json';
        FakeWeb.register_uri(:head,  url, :status => ["200", "OK"])
        connection = JenxConnection.new('http://fake.jenkins', 'user', 'pass')
        assert connection.is_connected?
    end

    def test_should_fail_if_user_and_password_is_wrong
        url = 'http://user:pass@fake.jenkins/api/json';
        FakeWeb.register_uri(:head,  url, :status => ["403", "Forbidden"])
        connection = JenxConnection.new('http://fake.jenkins', 'user', 'pass')
        assert !connection.is_connected?
    end

    def test_should_fail_if_can_not_connect
        url = 'http://fake.jenkins/api/json';
        FakeWeb.register_uri(:head,  url, :status => ["500", "Internal Error"])
        connection = JenxConnection.new('http://fake.jenkins')
        assert !connection.is_connected?
    end
end