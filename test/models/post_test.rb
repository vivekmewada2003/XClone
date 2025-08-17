require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @post = Post.new(user: @user, content: "This is a test post")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user should be present" do
    @post.user = nil
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end

  test "should broadcast after create" do
    assert_broadcasts('all_posts', 1) do
      @post.save
    end
  end

  test "should broadcast after update" do
    @post.save
    assert_broadcasts('all_posts', 1) do
      @post.update(content: "Updated content")
    end
  end

  test "should broadcast after destroy" do
    @post.save
    assert_broadcasts('all_posts', 1) do
      @post.destroy
    end
  end
end
