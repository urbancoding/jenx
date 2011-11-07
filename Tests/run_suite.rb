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
puts dir_path
Dir.glob(File.join(dir_path, '**/*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
    p = dir_path + '/' + path
    require(p) unless path == 'rb_main'
end

require File.expand_path('../JenxTestCase.rb',  __FILE__)
Dir.glob(File.expand_path('../**/*Test.rb', __FILE__)).each do |test| 
    require test 
end

