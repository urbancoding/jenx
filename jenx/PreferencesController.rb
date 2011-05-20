#
#  PreferencesController.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

class PreferencesController < NSWindowController
    attr_accessor :general_pane
    
    def self.sharedController
        unless @shared_instance
            @shared_instance = self.alloc.init
            general = PreferencesGeneralViewController.alloc.initWithNibName("PreferencesGeneralView", bundle:nil)
            @shared_instance.modules = [general]
        end
        @shared_instance
    end
    
    def init
        if super
            preferences_window = NSWindow.alloc.initWithContentRect(
                                                             NSMakeRect(0, 0, 550, 260),
                                                             styleMask:NSTitledWindowMask | NSClosableWindowMask,
                                                             backing:NSBackingStoreBuffered,
                                                             defer:true
                                                             )
            preferences_window.setShowsToolbarButton(false)
            self.window = preferences_window
            
            setup_toolbar
        end
        
        self
    end

    def toolbar(toolbar, itemForItemIdentifier:itemIdentifier, willBeInsertedIntoToolbar:flag)
        mod = module_for_identifier(itemIdentifier)
        item = NSToolbarItem.alloc.initWithItemIdentifier(itemIdentifier)
        
        if mod
            item.label = mod.title
            item.image = mod.image
            item.target = self;
            item.action = "select_module:"
        end
        
        item
    end

    def toolbarAllowedItemIdentifiers(toolbar)
        @modules.map { |mod| mod.identifier }
    end

    def toolbarDefaultItemIdentifiers(toolbar)
        nil
    end

    def toolbarSelectableItemIdentifiers(toolbar)
        toolbarAllowedItemIdentifiers(toolbar)
    end

    def showWindow(sender)
        self.window.center
        super
    end

    def select_module(sender)
        mod = module_for_identifier(sender.itemIdentifier)
        switch_to_module(mod) if mod
    end

    def modules=(new_modules)
        @modules = new_modules
        toolbar = self.window.toolbar
        return unless toolbar && toolbar.items.count == 0
        
        @modules.each do |mod|
            toolbar.insertItemWithItemIdentifier(mod.identifier, atIndex:toolbar.items.count)
        end
        
        saved_identifier = NSUserDefaults.standardUserDefaults.stringForKey(PREFERENCES_SELECTION)
        default_module = module_for_identifier(saved_identifier) || @modules.first
        switch_to_module(default_module)
    end

    private
    def setup_toolbar
        toolbar = NSToolbar.alloc.initWithIdentifier("preferences_toolbar")
        toolbar.delegate = self
        toolbar.setAllowsUserCustomization(false)
        self.window.setToolbar(toolbar)
    end

    def switch_to_module(mod)
        @current_module.view.removeFromSuperview if @current_module
        
        new_view = mod.view
        
        window_frame = self.window.frameRectForContentRect(new_view.frame)
        window_frame.origin = self.window.frame.origin;
        window_frame.origin.y -= window_frame.size.height - self.window.frame.size.height
        self.window.setFrame(window_frame, display:true, animate:true)
        
        self.window.toolbar.setSelectedItemIdentifier(mod.identifier)
        self.window.title = mod.title
        
        @current_module = mod
        self.window.contentView.addSubview(@current_module.view)
        self.window.setInitialFirstResponder(@current_module.view)
        
        NSUserDefaults.standardUserDefaults.setObject(mod.identifier, forKey:PREFERENCES_SELECTION)
    end

    def module_for_identifier(identifier)
        @modules.find { |mod| mod.identifier == identifier }
    end
end