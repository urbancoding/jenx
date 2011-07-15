#
#  rb_main.rb
#  jenx
#
#  Created by Trent Kocurek on 5/18/11.
#  Copyright (c) 2011 Urban Coding. Released under the MIT license.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'
framework 'Growl'

require 'rubygems'
require 'json'
require 'timeout'
require 'net/http'
require 'open-uri'

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
