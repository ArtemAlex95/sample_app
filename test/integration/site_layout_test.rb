require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test 'layout links if not logged in' do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", sign_up_path
    get contact_path
    assert_select "title", full_title("Contact")
    get sign_up_path
    assert_select "title", full_title("Sign up")
  end

  test 'layout links if logged in' do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", followers_user_path(@user)
    assert_select "a[href=?]", following_user_path(@user)
    assert_select "div.field"
    get contact_path
    assert_select "title", full_title('Contact')
    get sign_up_path
    assert_select "title", full_title('Sign up')
    get about_path
    assert_select "title", full_title('About')
    get help_path
    assert_select "title", full_title('Help')
  end
end
