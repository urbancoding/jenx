#
#  AppDelegate.rb
#  jenx
#
#  Created by Trent Kocurek on 5/18/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#
require 'rubygems'
require 'json'
require 'open-uri'

class AppDelegate
    JENKINS_URL = '' #enter your url here
    API_URL_EXTENSION = 'api/json'
    
    attr_accessor :menu
    
    def awakeFromNib
        @status_bar = NSStatusBar.systemStatusBar
        @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
        @status_item.setHighlightMode(true)
        @status_item.setMenu(@menu)
        
        @app_icon = NSImage.imageNamed('app.tif')
        @build_failure_icon = NSImage.imageNamed('build_failure.tif')
        
        @status_item.setImage(@app_icon)
        @status_item.menu.insertItem(NSMenuItem.separatorItem, atIndex:1)
        
        load_jobs
    end
    
    def get_build_status(sender)
    end
    
    def load_jobs
        results = JSON.parse(open(JENKINS_URL + API_URL_EXTENSION).string)
        
        results['jobs'].each_with_index do |job, index|
            builds_menu_item = NSMenuItem.alloc.init
            builds_menu_item.title = " " + job['name']
            builds_menu_item.enabled = true
            builds_menu_item.setImage(NSImage.imageNamed('app.tif'))
            @status_item.menu.insertItem(builds_menu_item, atIndex:index + 2)
        end
    end
end

