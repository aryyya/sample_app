require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test("full_title helper") do
    assert_equal(full_title, "Ruby on Rails Tutorial Sample App")
    assert_equal(full_title('Test'), "Test | Ruby on Rails Tutorial Sample App")
  end

end
