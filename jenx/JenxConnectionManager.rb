#
#  JenxConnectionManager.rb
#  jenx
#
#  Created by Trent Kocurek on 5/23/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

class JenxConnectionManager
    def initialize(&block)
        @queue ||= Dispatch::Queue.new("com.urbancoding.jenx")
        @group = Dispatch::Group.new
        
        @queue.async(@group) { @value = block.call }
    end
    
    def value
        @group.wait(8)
        @value
    end
end