module UsersHelper

  def gravatar_for(user, size: 80)
    email_digest = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://www.gravatar.com/avatar/#{email_digest}?s=#{size}"
    return image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end

end
