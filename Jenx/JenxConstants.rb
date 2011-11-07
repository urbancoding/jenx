#
#  JenxConstants.rb
#  jenx
#
#  Created by Trent Kocurek on 5/19/11.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#

#global
JENX_API_URI = "/api/json"
JENX_STARTING_PROJECT_MENU_INDEX = 9
JENX_REFRESH_TIME_INTERVAL = 10.0 #seconds

#preferences
PREFERENCES_TOTAL_NUM_PROJECTS = "total_num_projects"
PREFERENCES_BUILD_SERVER_URL = "build_server_url"
PREFERENCES_BUILD_SERVER_USERNAME = "build_server_username"
PREFERENCES_BUILD_SERVER_PASSWORD = "build_server_password"
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
CONNECTION_ERROR_TITLE = localize("Connection Error", "Connection Error")
CONNECTION_ERROR_MESSAGE = localize("Cannot connect to build server.", "Cannot connect to build server.")
CANNOT_CONNECT = localize("Jenx Status: Not Connected", "Jenx Status: Not Connected")
CONNECTED = localize("Jenx Status: Connected","Jenx Status: Connected")

#growl notification types
CONNECTION_FAILURE = localize("Connection Failure", "Connection Failure")
BUILD_FAILURE = localize("Build Failure", "Build Failure")
BUILD_SUCCESS = localize("Build Success", "Build Success")
BUILD_ISSUES = localize("Build has Issues","Build has Issues") 