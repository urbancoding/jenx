#
#  Jenx.rb
#  jenx
#
#  Created by Trent Kocurek on 5/18/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

framework 'Growl'
require 'rubygems'
require 'json'
require 'open-uri'

class Jenx
    attr_accessor :menu 
    attr_accessor :menu_default_project
    attr_accessor :menu_default_project_status
    attr_accessor :menu_default_project_update_time
    
    def awakeFromNib
        @initial_load = true
        
        @status_bar = NSStatusBar.systemStatusBar
        @jenx_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
        @jenx_item.setHighlightMode(true)
        @jenx_item.setMenu(@menu)
        
        JenxPreferences::setup_defaults
        @preferences = JenxPreferences.sharedInstance
        @notification_center = JenxNotificationCenter.new(@preferences)
        
        @build_status_default_project = '';
        @build_status_all_projects = [];
        
        initialize_menu_ui_items
        register_observers
    end
    
    def update_for_preferences(sender)
        NSLog("Preferences saved, recreating timer...")
        @initial_load = true

        ensure_connection(nil)
    end 
    
    def ensure_connection(sender)
        NSLog("Checking connection...")
        
        @initial_load ? @menu_default_project.setTitle("Refreshing...") : @menu_default_project.setTitle("Connecting...")
        if @refresh_timer.nil? || !@refresh_timer.isValid
            create_timer
        end
        JenxConnection.new(@preferences.build_server_url).is_connected? ? fetch_current_build_status : handle_broken_connection(ERROR_SERVER_CANNOT_BE_CONTACTED)
    end
    
    def fetch_current_build_status
        @all_projects = JSON.parse(open(@preferences.build_server_url + JENX_API_URI).string)
        NSLog("Fetching current build status for #{@all_projects['jobs'].count} projects...")

        default_project_status_color = nil
        @all_projects['jobs'].find {|p| default_project_status_color = p['color'] if p['name'].downcase.eql?(@preferences.default_project.downcase)}
        
        @menu_default_project.setTitle("Project: " + @preferences.default_project)
        @menu_default_project_status.setTitle("Status: " + get_current_status_for(default_project_status_color))
        @menu_default_project_update_time.setTitle(Time.now.strftime("Last Update: %I:%M:%S %p"))
        
        @build_status_default_project = default_project_status_color
        
        @jenx_item.setImage(get_current_status_icon_for(default_project_status_color, nil))

        load_projects
    rescue Exception => e
        NSLog("Error while fetching build status for " + @preferences.default_project + ": " + e.message)
        retry
    end
    
    def load_projects
        project_menu_count = (@preferences.num_menu_projects == 0 || @preferences.num_menu_projects.nil?) ? 3 : @preferences.num_menu_projects
        if @initial_load
            NSLog("Initial load of project menu items with " + project_menu_count.to_s + " projects...")
            @all_projects['jobs'].each_with_index do |project, index|
                if index < project_menu_count
                    project_menu_item = NSMenuItem.alloc.init
                    project_menu_item.setTitle(" " + project['name'])
                    project_menu_item.setToolTip(get_job_url_for(project['name']))
                    project_menu_item.setEnabled(true)
                    project_menu_item.setIndentationLevel(1)
                    project_menu_item.setImage(get_current_status_icon_for(project['color'], nil))
                    project_menu_item.setAction("open_web_interface_for:")
                    project_menu_item.setTag(index + 1)
                    @jenx_item.menu.insertItem(project_menu_item, atIndex:index + JENX_STARTING_PROJECT_MENU_INDEX)
                    
                    @build_status_all_projects << :red if project['color'].eql?("red")
                end
            end
            
            view_all_menu_item = NSMenuItem.alloc.init
            view_all_menu_item.setTitle("View all projects..")
            view_all_menu_item.setToolTip(@preferences.build_server_url)
            view_all_menu_item.setIndentationLevel(1)
            view_all_menu_item.setAction("open_web_interface_for:")
            view_all_menu_item.setTag(project_menu_count + 1)
            @jenx_item.menu.insertItem(view_all_menu_item, atIndex:project_menu_count + JENX_STARTING_PROJECT_MENU_INDEX)
            
            @initial_load = false
        else
            NSLog("Refreshing project menu items...")
            
            @build_status_all_projects = []
            
            @all_projects['jobs'].each_with_index do |project, index| 
                if index < project_menu_count
                    project_menu_item = @jenx_item.menu.itemAtIndex(index + JENX_STARTING_PROJECT_MENU_INDEX)
                    project_menu_item.setImage(get_current_status_icon_for(project['color'], project_menu_item.image.name))
                    
                    @build_status_all_projects << :red if project['color'].eql?("red")
                end
            end
        end
        present_build_status
    end
    
    def handle_broken_connection(error_type)
        NSLog("#{CONNECTION_ERROR}: " + error_type)
        @jenx_item.setImage(@build_failure_icon)
        
        if error_type == ERROR_NO_INTERNET_CONNECTION
            @menu_default_project.setTitle(CANNOT_CONNECT_TO_INTERNET)
            @menu_default_project.setToolTip(CANNOT_CONNECT_TO_INTERNET)
            @notification_center.notify(CONNECTION_ERROR, CANNOT_CONNECT_TO_INTERNET, "", CONNECTION_FAILURE)
        else
            @menu_default_project.setTitle(CANNOT_CONNECT_TO_BUILD_SERVER)
            @menu_default_project.setToolTip(CANNOT_CONNECT_TO_BUILD_SERVER)
            @notification_center.notify(CONNECTION_ERROR, CANNOT_CONNECT_TO_BUILD_SERVER, "", CONNECTION_FAILURE)
        end
        
        clear_projects_from_menu
    end
    
    def clear_projects_from_menu
        project_menu_count = (@preferences.num_menu_projects == 0 || @preferences.num_menu_projects.nil?) ? 3 : @preferences.num_menu_projects
        
        NSLog("Clearing " + project_menu_count.to_s + " items from the menu if they exist...")
        
        for i in 1..project_menu_count
            @jenx_item.menu.removeItem(@jenx_item.menu.itemWithTag(i)) if @jenx_item.menu.itemWithTag(i)
        end
    end
    
    def create_timer
        time = (@preferences.refresh_time == 0) ? 5 : @preferences.refresh_time
        NSLog("Create timer with refresh_time of: " + time.to_s + " seconds...")
        @refresh_timer = NSTimer.scheduledTimerWithTimeInterval(time, target:self, selector:"ensure_connection:", userInfo:nil, repeats:true)
    end
    
    def open_web_interface_for(sender)
        project_url = NSURL.alloc.initWithString(sender.toolTip)
        workspace = NSWorkspace.sharedWorkspace
        workspace.openURL(project_url)
    end
    
    def show_preferences_window(sender)
        clear_projects_from_menu
        NSApplication.sharedApplication.activateIgnoringOtherApps(true)
        PreferencesController.sharedController.showWindow(sender)
    end
    
    private
    
        def initialize_menu_ui_items
            @app_icon = NSImage.imageNamed('app.tiff')
            @connecting_icon = NSImage.imageNamed('connecting.tiff')
            
            @build_success_icon = NSImage.imageNamed('build_success.tiff')
            @build_failure_icon = NSImage.imageNamed('build_failure.tiff')
            @build_initiated_icon = NSImage.imageNamed('build_initiated.tiff')
            
            @jenx_success = NSImage.imageNamed('jenx_success.tiff')
            @jenx_failure = NSImage.imageNamed('jenx_failure.tiff')
            @jenx_issues = NSImage.imageNamed('jenx_yield.tiff')
        end
    
        def register_observers
            notification_center = NSNotificationCenter.defaultCenter
            notification_center.addObserver(
               self,
               selector:"update_for_preferences:",
               name:NOTIFICATION_PREFERENCES_UPDATED,
               object:nil
            )
            
            notification_center.addObserver(
               self,
               selector:"update_for_preferences:",
               name:NSWindowWillCloseNotification,
               object:nil
            )
            
            notification_center.addObserver(
               self,
               selector:"ensure_connection:",
               name:NSApplicationDidFinishLaunchingNotification,
               object:nil
            )
        end
    
        def get_job_url_for(project)
            "#{@preferences.build_server_url}/job/#{project}"
        end
    
        def get_current_status_icon_for(color, current_image)
            case color.to_sym
                when :red
                    @build_failure_icon
                when :blue_anime
                    @build_initiated_icon
                else
                    @app_icon
            end
        end
        
        def get_current_status_for(color)
            if @preferences.default_project.empty?
                "No default project set"
            end
            
            case color.to_sym
                when ""
                    "Could not retrieve status"
                when :red
                    "Broken"
                when :blue_anime
                    "Building"
                else
                    "Stable"
            end
        end
    
        def present_build_status
            
            num_failed_projects = @build_status_all_projects.count
            
            case @build_status_default_project.to_sym
                when :red
                    if (num_failed_projects != @preferences.num_menu_projects && num_failed_projects > 0)
                        @notification_center.notify(@preferences.default_project + " has failed", "You also have #{num_failed_projects} project(s) that are failing.", @jenx_failure.TIFFRepresentation, BUILD_FAILURE)
                    else if (num_failed_projects == @preferences.num_menu_projects)
                        @notification_center.notify(BUILD_FAILURE, "All projects are failing.", @jenx_failure.TIFFRepresentation, BUILD_FAILURE)
                    end
                end
            when :blue
                    if (num_failed_projects != @preferences.num_menu_projects && num_failed_projects > 0)
                        @notification_center.notify(@preferences.default_project + " has passed", "Although, #{num_failed_projects} project(s) are failing.", @jenx_issues.TIFFRepresentation, BUILD_ISSUES)
                    else if (num_failed_projects == @preferences.num_menu_projects)
                        @notification_center.notify(@preferences.default_project + " has passed", "Although, all other projects are failing.", @jenx_issues.TIFFRepresentation, BUILD_ISSUES)
                    else
                        @notification_center.notify(BUILD_SUCCESS, "All projects are passing!", @jenx_success.TIFFRepresentation, BUILD_SUCCESS)
                    end
                end
            end
        end
end