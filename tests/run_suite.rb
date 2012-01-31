#sudo macgem install fakeweb

framework 'Cocoa'
framework 'Growl'

require 'rubygems'
require 'json'
require 'timeout'
require 'net/https'
require 'open-uri'
require 'test/unit'
require 'fakeweb'

FakeWeb.allow_net_connect = false

# Loading all the Ruby project files.
dir_path = File.expand_path('../../jenx/', __FILE__)
['JenxLocalize', 'JenxConstants', 'JenxConnection', 'JenxConnectionManager'].each do |class_name|
	require "#{dir_path}/#{class_name}.rb"
end

require File.expand_path('../JenxTestCase.rb',  __FILE__)
Dir.glob(File.expand_path('../**/*Test.rb', __FILE__)).each do |test|
    require test 
end
