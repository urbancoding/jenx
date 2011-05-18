#
#  AppDelegate.rb
#  jenx
#
#  Created by Trent Kocurek on 5/18/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

class AppDelegate
    attr_accessor :menu
    
    def awakeFromNib
        @status_bar = NSStatusBar.systemStatusBar
        @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
        @status_item.setHighlightMode(true)
        @status_item.setMenu(@menu)
        
        @app_icon = NSImage.imageNamed('app.tif')
        
        @status_item.setImage(@app_icon)
    end
    
    def get_build_status(sender)
    end
end

