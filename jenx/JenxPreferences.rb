#
#  JenxPreferences.rb
#  jenx
#
#  Created by Trent Kocurek on 5/20/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

class JenxPreferences
    attr_accessor :projects
    
    def self.sharedInstance
        @instance ||= self.alloc.init
    end

    def init
        super
        defaults = NSUserDefaults.standardUserDefaults
        self
    end

    def build_server_url
        NSUserDefaults.standardUserDefaults.stringForKey(PREFERENCES_BUILD_SERVER_URL) 
    end

    def build_server_url=(val)
        NSUserDefaults.standardUserDefaults.setObject(val, forKey:PREFERENCES_BUILD_SERVER_URL)
        NSUserDefaults.standardUserDefaults.synchronize
    end

    def default_project
        NSUserDefaults.standardUserDefaults.stringForKey(PREFERENCES_DEFAULT_PROJECT)
    end

    def default_project=(val)
        NSUserDefaults.standardUserDefaults.setObject(val, forKey:PREFERENCES_DEFAULT_PROJECT)
        NSUserDefaults.standardUserDefaults.synchronize
    end

    def refresh_time
        NSUserDefaults.standardUserDefaults.integerForKey(PREFERENCES_REFRESH_TIME_INTERVAL)
    end

    def refresh_time=(val)
        NSUserDefaults.standardUserDefaults.setInteger(val, forKey:PREFERENCES_REFRESH_TIME_INTERVAL)
        NSUserDefaults.standardUserDefaults.synchronize
    end

    def num_menu_projects
        NSUserDefaults.standardUserDefaults.integerForKey(PREFERENCES_MAX_PROJECTS_TO_SHOW)
    end

    def num_menu_projects=(val)
        NSUserDefaults.standardUserDefaults.setInteger(val, forKey:PREFERENCES_MAX_PROJECTS_TO_SHOW)
        NSUserDefaults.standardUserDefaults.synchronize
    end

    def enable_growl?
        NSUserDefaults.standardUserDefaults.boolForKey(PREFERENCES_ENABLE_GROWL)
    end

    def enable_growl=(val)
        NSUserDefaults.standardUserDefaults.setObject(val, forKey:PREFERENCES_ENABLE_GROWL)
        NSUserDefaults.standardUserDefaults.synchronize
    end

    class << self
        def setup_defaults
            NSUserDefaults.standardUserDefaults.registerDefaults(
                NSDictionary.dictionaryWithObjectsAndKeys(
                   PREFERENCES_TOOLBAR_ITEM_GENERAL, PREFERENCES_SELECTION,
                   nil))
        end
    end
end