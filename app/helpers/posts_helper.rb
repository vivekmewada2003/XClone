module PostsHelper
  def parent_emails(post)
    emails = []
    current_post = post

    while current_post.parent.present?
      parent_post = current_post.parent
      emails << parent_post.user.email
      current_post = parent_post
    end
    emails.uniq
  end
end
