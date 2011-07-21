#
#  JenxConstants.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

#global
JENX_API_URI = "api/json"
JENX_STARTING_PROJECT_MENU_INDEX = 9
JENX_REFRESH_TIME_INTERVAL = 10.0 #seconds

#preferences
PREFERENCES_TOTAL_NUM_PROJECTS = "total_num_projects"
PREFERENCES_BUILD_SERVER_URL = "build_server_url"
PREFERENCES_DEFAULT_PROJECT = "default_project"
PREFERENCES_MAX_PROJECTS_TO_SHOW = "max_project_to_show"
PREFERENCES_REFRESH_TIME_INTERVAL = "refresh_time_interval"
PREFERENCES_ENABLE_GROWL = "enable_growl"
PREFERENCES_ENABLE_AUTO_LAUNCH = "enable_auto_launch"

PREFERENCES_SELECTION = "preferences_selection"
PREFERENCES_TOOLBAR_ITEM_GENERAL = "preferences_toolbar_item_general"

#notifications
NOTIFICATION_PREFERENCES_UPDATED = "preferences_updated"

#errors
ERROR_NO_INTERNET_CONNECTION = "no_internet_connection"
ERROR_SERVER_CANNOT_BE_CONTACTED = "server cannot be contacted"
CONNECTION_ERROR = "connection error"
CANNOT_CONNECT_TO_BUILD_SERVER = "Connection to build server cannot be established."
CANNOT_CONNECT_TO_INTERNET = "Internet connection cannot be established."

#growl notification types
CONNECTION_FAILURE = "Connection Failure"
BUILD_FAILURE = "Build Failure"
BUILD_SUCCESS = "Build Success"
BUILD_ISSUES = "Build has Issues" 