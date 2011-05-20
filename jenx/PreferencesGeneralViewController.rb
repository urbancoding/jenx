#
#  PreferencesViewController.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

class PreferencesGeneralViewController <  NSViewController
    attr_accessor :project_list
    attr_accessor :enable_growl
    attr_accessor :connection_spinner
    attr_accessor :connection_label
    
    def title
        "Settings"
    end
    
    def image
        NSImage.imageNamed("NSPreferencesGeneral")
    end
    
    def identifier
        PREFERENCES_TOOLBAR_ITEM_GENERAL
    end
    
    def loadView
        super
        @project_list.target = self
    end
end