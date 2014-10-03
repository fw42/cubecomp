module Admin::AvatarHelper
  def avatar_url(user, size)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def small_avatar_image(user)
    image_tag avatar_url(user, 25)
  end
end
