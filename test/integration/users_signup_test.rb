require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test('invalid signup information') do
    get(signup_path)
    assert_select('form[action=?]', '/signup')
    assert_no_difference('User.count') do
      post(signup_path, params: {
        user: {
          name: '',
          email: 'user@invalid',
          password: 'foo',
          password_confirmation: 'bar'
        }
      })
    end
    assert_template('users/new')
    assert_select('div[id=?]', 'error_explanation')
    assert_select('div[class=?]', 'field_with_errors')
  end

  test('valid signup information') do
    get(signup_path)
    assert_select('form[action=?]', '/signup')
    assert_difference('User.count', 1) do
      post(signup_path, params: {
        user: {
          name: 'Example User',
          email: 'user@example.com',
          password: 'helloworld',
          password_confirmation: 'helloworld'
        }
      })
    end
    follow_redirect!
    assert_template('users/show')
    assert_select('div[class=?]', 'alert alert-success')
    assert(logged_in?)
  end

end
