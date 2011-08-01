#
#  JenxTestCase.rb
#  jenx
#
#  Created by Roman Dmytrenko.
#  Copyright 2011 Urban Coding. Released under the MIT license.
#
class JenxTestCase < Test::Unit::TestCase

    def teardown
        FakeWeb.clean_registry
    end
end