#
#  JenxUtils.rb
#  jenx
#
#  Created by Johan BLEUZEN on 16/09/11.
#  Copyright 2011 Urban Coding. All rights reserved.
#

def localize(key, default_value = "")
    NSBundle.mainBundle.localizedStringForKey(key, value: default_value, table: nil)
end

#varargs don't work yet
def localize_format(key, placeholder_value)
    format_str = localize(key, nil)
    puts format_str
    NSString.stringWithFormat(format_str, placeholder_value)
end
