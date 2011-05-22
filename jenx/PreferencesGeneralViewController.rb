#
#  PreferencesViewController.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

class PreferencesGeneralViewController <  NSViewController
    attr_accessor :server_url
    attr_accessor :project_list
    attr_accessor :connection_spinner
    attr_accessor :connection_label
    attr_accessor :default_project
    attr_accessor :refresh_time
    attr_accessor :num_menu_projects
    attr_accessor :enable_growl
    
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
        @server_url.stringValue = JenxPreferences.sharedInstance.build_server_url
    end
    
    def save_build_server_url(sender)
        JenxPreferences.sharedInstance.build_server_url = server_url.stringValue
        NSNotificationCenter.defaultCenter.postNotificationName(NOTIFICATION_ADDED_SERVER_URL, object:self)
    end
end