module Admin::AvatarHelper
  def avatar_url(email, size)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def small_avatar_image(user)
    image_tag avatar_url(user.email, 25)
  end

  def large_avatar_image(user)
    image_tag avatar_url(user.email, 50)
  end
end
