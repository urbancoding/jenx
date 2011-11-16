#
#  PreferencesViewController.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

class PreferencesGeneralViewController <  NSViewController
    attr_accessor :server_url
    attr_accessor :username
    attr_accessor :password
    attr_accessor :project_list
    attr_accessor :connection_spinner
    attr_accessor :connection_label
    attr_accessor :default_project
    attr_accessor :refresh_time
    attr_accessor :num_menu_projects
    attr_accessor :enable_growl
    attr_accessor :launch_at_login
    
    def title
        localize("Settings", "Settings")
    end
    
    def image
        NSImage.imageNamed("NSPreferencesGeneral")
    end
    
    def identifier
        PREFERENCES_TOOLBAR_ITEM_GENERAL
    end
    
    def loadView
        super
        begin
            @prefs = JenxPreferences.sharedInstance
            
            @server_url.stringValue = (@prefs.build_server_url.nil? || @prefs.build_server_url.eql?('')) ? '' : @prefs.build_server_url
            @refresh_time.intValue = (@prefs.refresh_time.nil? || @prefs.refresh_time.eql?('')) ? 0 : @prefs.refresh_time
            @num_menu_projects.intValue = (@prefs.num_menu_projects.nil? || @prefs.num_menu_projects.eql?('')) ? 0 : @prefs.num_menu_projects
            @enable_growl.state = @prefs.enable_growl? ? NSOnState : NSOffState
            @launch_at_login.state = @prefs.launch_at_login? ? NSOnState : NSOffState
            @username.stringValue = (@prefs.username.nil?) ? '' : @prefs.username
            @password.stringValue = (@prefs.password.nil?) ? '' : @prefs.password
            load_projects
        rescue Exception => e
            NSLog(e.message)
        end
    end
    
    def load_projects(sender=nil)
        @project_list.removeAllItems
        begin
            url = @server_url.stringValue[-1,1].eql?('/') ? @server_url.stringValue : @server_url.stringValue + '/'
            @all_projects =  JenxConnection.new(url, @username.stringValue, @password.stringValue).all_projects
            @all_projects['jobs'].each do |project|
                @project_list.addItemWithObjectValue(project['name'])
            end
            
            if !@prefs.default_project
                @project_list.selectItemWithObjectValue(0)
            else
                @project_list.selectItemWithObjectValue(@prefs.default_project)
            end
        rescue URI::InvalidURIError => uri_error
            NSLog(uri_error)
        rescue Exception => error
            NSLog(error)
        end
    end
    
    def save_preferences(sender)
        @prefs.total_num_projects = @all_projects.count
        @prefs.build_server_url = @server_url.stringValue[-1,1].eql?('/') ? @server_url.stringValue : @server_url.stringValue + '/'
        @prefs.username = @username.stringValue
        @prefs.password = @password.stringValue
        @prefs.default_project = @project_list.objectValueOfSelectedItem
        @prefs.refresh_time = @refresh_time.intValue
        @prefs.num_menu_projects = (@num_menu_projects.intValue > @project_list.numberOfItems) ? @project_list.numberOfItems : @num_menu_projects.intValue
        @prefs.enable_growl = (@enable_growl.state == NSOnState)
        @prefs.launch_at_login = (@launch_at_login.state == NSOnState)
        
        NSNotificationCenter.defaultCenter.postNotificationName(NOTIFICATION_PREFERENCES_UPDATED, object:self)
        
        self.view.window.close
    end
end
