#
#  AppDelegate.rb
#  jenx
#
#  Created by Trent Kocurek on 5/18/11.
#  Copyright 2011 Urban Coding. Released under the MIT license..
#

require 'rubygems'
require 'json'
require 'open-uri'
require 'net/http'

class Jenx
    attr_accessor :menu, :status_menu_item, :refresh_menu_item
    
    def awakeFromNib
        @initial_load = true
        
        @status_bar = NSStatusBar.systemStatusBar
        @jenx_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
        @jenx_item.setHighlightMode(true)
        @jenx_item.setMenu(@menu)
        
        JenxPreferences::setup_defaults
        
        @preferences = JenxPreferences.sharedInstance
        
        initialize_menu_ui_items
        
        register_observers
        
        connect_to_server
    end
    
    def initialize_menu_ui_items
        @app_icon = NSImage.imageNamed('app.tiff')
        
        @build_success_icon = NSImage.imageNamed('build_success.tiff')
        @build_failure_icon = NSImage.imageNamed('build_failure.tiff')
        @build_initiated_icon = NSImage.imageNamed('build_initiated.tiff')
    end
    
    def connect_to_server
        if !@preferences.build_server_url.empty?
            @refresh_timer = NSTimer.scheduledTimerWithTimeInterval(@preferences.refresh_time, target:self, selector:"refresh_status:", userInfo:nil, repeats:true)
            refresh_status(nil)
        else
            handle_broken_connection
        end
    end
        
    def fetch_current_build_status
        if connection_can_be_established
            @all_projects = JSON.parse(open(JENX_BUILD_SERVER_URL + JENX_API_URI).string)
            
            status_color = ""
            if !JENX_DEFAULT_PROJECT.nil?
                @all_projects['jobs'].each do |j| 
                    status_color = j['color'] if j['name'] == JENX_DEFAULT_PROJECT
                end
            end
            
            @status_menu_item.setTitle(get_current_status_for(status_color))
            @jenx_item.setImage(@app_icon)
            
            load_projects
        else
            handle_broken_connection
        end
    end
    
    def load_projects
        if @initial_load
            @all_projects['jobs'].each_with_index do |project, index|
                if index < JENX_MAX_PROJECTS_TO_SHOW
                    project_menu_item = NSMenuItem.alloc.init
                    project_menu_item.setTitle(" " + project['name'])
                    project_menu_item.setToolTip(project['url'])
                    project_menu_item.setEnabled(true)
                    project_menu_item.setIndentationLevel(1)
                    project_menu_item.setImage(get_current_status_icon_for(project['color']))
                    project_menu_item.setAction("open_web_interface_for:")
                    @jenx_item.menu.insertItem(project_menu_item, atIndex:index + JENX_STARTING_PROJECT_MENU_INDEX)
                end
            end
            
            view_all_menu_item = NSMenuItem.alloc.init
            view_all_menu_item.setTitle("View all projects..")
            view_all_menu_item.setToolTip(JENX_BUILD_SERVER_URL)
            view_all_menu_item.setIndentationLevel(1)
            view_all_menu_item.setAction("open_web_interface_for:")
            @jenx_item.menu.insertItem(view_all_menu_item, atIndex:JENX_MAX_PROJECTS_TO_SHOW + JENX_STARTING_PROJECT_MENU_INDEX)
            
            @initial_load = false
        else
            @all_projects['jobs'].each_with_index do |project, index| 
                if index < JENX_MAX_PROJECTS_TO_SHOW
                    project_menu_item = @jenx_item.menu.itemAtIndex(index + JENX_STARTING_PROJECT_MENU_INDEX)
                    project_menu_item.setImage(get_current_status_icon_for(project['color']))
                end
            end
        end
    end
    
    def handle_broken_connection
        @refresh_timer.invalidate if @refresh_timer
        
        @jenx_item.setImage(@build_failure_icon)
        
        @refresh_menu_item.setEnabled(false)
        @refresh_menu_item.setAction(nil)
        
        @status_menu_item.setTitle("Connection to build server cannot be established.")
        @status_menu_item.setToolTip("Connection to build server cannot be established.")
    end
    
    def connection_can_be_established
        url = JENX_BUILD_SERVER_URL
        begin
            result = Net::HTTP.get_response(URI.parse(url))
        rescue
            return false
        end
        
        return !result.is_a?(Net::HTTPNotFound)
    end
    
    def get_current_status_icon_for(color)
        case color
            when "red"
                return @build_failure_icon
            when "blue_anime"
                return @build_initiated_icon
            else
                return @build_success_icon
        end
    end
    
    def get_current_status_for(color)
        if JENX_DEFAULT_PROJECT.nil?
            return "No default project set"
        end
        
        case color
            when ""
                return "Could not retrieve status"
            when "red"
                return JENX_DEFAULT_PROJECT + ": Broken"
            when "blue_anime"
                return JENX_DEFAULT_PROJECT + ": Building"
            else
                return JENX_DEFAULT_PROJECT + ": Stable"
        end
    end
    
    #actions
    def refresh_status(sender)
        fetch_current_build_status
    end
    
    def open_web_interface_for(sender)
        project_url = NSURL.alloc.initWithString(sender.toolTip)
        workspace = NSWorkspace.sharedWorkspace
        workspace.openURL(project_url)
    end
    
    def show_preferences_window(sender)
        NSApplication.sharedApplication.activateIgnoringOtherApps(true)
        PreferencesController.sharedController.showWindow(sender)
    end
    
    def finished_adding_server_url(sender)
        connect_to_server
    end
    
    private
        def register_observers
            notification_center = NSNotificationCenter.defaultCenter
            notification_center.addObserver(
               self,
               selector:"finished_adding_server_url:",
               name:NOTIFICATION_ADDED_SERVER_URL,
               object:nil
            )
        end
end

