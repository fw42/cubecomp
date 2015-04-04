module Admin::AvatarHelper
  def avatar_url(user, size)
    gravatar_id = Digest::MD5.hexdigest(user.email.try!(:downcase) || '')
    "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def large_avatar_image(user)
    avatar_image(user, 50)
  end

  def small_avatar_image(user)
    avatar_image(user, 25)
  end

  def avatar_image(user, size)
    image_tag(avatar_url(user, size), width: size, height: size)
  end
end
