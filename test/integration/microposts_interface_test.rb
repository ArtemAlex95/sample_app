require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'micropost intreface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '   '} }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'
    # Valid submission
    content = 'Lorem Ips'
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg', :binary)
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert assigns(:micropost).image.attached?
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(micropost)
    end
    # Visit another user - no delete links
    get user_path(users(:other_user))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    different_user = users(:malory)
    log_in_as(different_user)
    get root_path
    assert_match '0 microposts', response.body
    different_user.microposts.create!(content: 'Lorem Ipsum')
    get root_path
    assert_match '1 micropost', response.body
  end
end
