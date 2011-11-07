#
#  JenxStartup.rb
#  jenx
#
#  Created by Trent Kocurek on 7/13/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

class JenxStartup
    def is_set?
        copy_value = CFPreferencesCopyValue("AutoLaunchedApplicationDictionary", "loginwindow", KCFPreferencesCurrentUser, KCFPreferencesAnyHost)
        
        return false unless copy_value
        
        copy_value.any? { |application| path == application["Path"] }
    end
    
    def set(auto_launch)
        if auto_launch != is_set?
            copy_value = CFPreferencesCopyValue("AutoLaunchedApplicationDictionary", "loginwindow", KCFPreferencesCurrentUser, KCFPreferencesAnyHost)
            
            if copy_value
                copy_value = copy_value.mutableCopy
            else
                copy_value = NSMutableArray.alloc.init
            end
            
            if auto_launch
                copy_value.addObject(NSDictionary.dictionaryWithObject(path, forKey:"Path"))
            else
                to_remove = nil
                
                copy_value.each do |application|
                    to_remove = application and break if application.valueForKey("Path") == path
                end
                
                copy_value.removeObject(to_remove) if to_remove
            end
            
            CFPreferencesSetValue("AutoLaunchedApplicationDictionary", copy_value, "loginwindow", KCFPreferencesCurrentUser, KCFPreferencesAnyHost)
            
            CFPreferencesSynchronize("loginwindow", KCFPreferencesCurrentUser, KCFPreferencesAnyHost)
        end
    end
    
    def path
        @path ||= NSBundle.mainBundle.bundlePath
    end
end