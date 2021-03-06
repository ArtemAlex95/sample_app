require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'John', email: 'example@mail.ru', password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '     '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'user name should not be long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'user email should not be long' do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test 'email validation should reject invalid email' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated should return false for a user with the nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow users' do
    user = users(:michael)
    other_user = users(:other_user)
    assert_not user.following?(other_user)
    user.follow(other_user)
    assert user.following?(other_user)
    assert other_user.followers.include?(user)
    user.unfollow(other_user)
    assert_not user.following?(other_user)
  end

  test 'feed should have the right posts' do
    michael = users(:michael)
    other_user = users(:other_user)
    lana = users(:lana)
    # Posts from followed users
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post|
      assert michael.feed.include?(post)
    end
    # Posts from unfollowed users
    other_user.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
