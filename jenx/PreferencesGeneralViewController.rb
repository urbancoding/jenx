#
#  PreferencesViewController.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
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
    attr_accessor :launch_at_login
    
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
        @preferences = JenxPreferences.sharedInstance
        
        @server_url.stringValue = @preferences.build_server_url
        @refresh_time.intValue = @preferences.refresh_time
        @num_menu_projects.intValue = @preferences.num_menu_projects
        @enable_growl.state = @preferences.enable_growl? ? NSOnState : NSOffState
        @launch_at_login.state = @preferences.launch_at_login? ? NSOnState : NSOffState
        
        load_projects(nil)
    end
    
    def load_projects(sender)
        @all_projects = JSON.parse(open(@server_url.stringValue + JENX_API_URI).string)
        
        @all_projects['jobs'].each do |project|
            @project_list.addItemWithObjectValue(project['name'])
        end
        
        if !@preferences.default_project
            @project_list.selectItemWithObjectValue(0)
        else
            @project_list.selectItemWithObjectValue(@preferences.default_project)
        end
    end
    
    def save_preferences(sender)
        @preferences.build_server_url = @server_url.stringValue[-1,1].eql?('/') ? @server_url.stringValue : @server_url.stringValue + '/'
        @preferences.default_project = @project_list.objectValueOfSelectedItem
        @preferences.refresh_time = @refresh_time.intValue
        @preferences.num_menu_projects = @num_menu_projects.intValue
        @preferences.enable_growl = (@enable_growl.state == NSOnState)
        @preferences.launch_at_login = (@launch_at_login.state == NSOnState)
        
        @preferences.first_jenx_run = false;
        
        NSNotificationCenter.defaultCenter.postNotificationName(NOTIFICATION_PREFERENCES_UPDATED, object:self)
        
        self.view.window.close
    end
end