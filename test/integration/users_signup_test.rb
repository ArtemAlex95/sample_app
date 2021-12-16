require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid sign up information' do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test 'valid sign up information' do
    get sign_up_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'test',
                                         email: 'test@valid.com',
                                         password: 'foobar',
                                         password_confirmation: 'foobar' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
