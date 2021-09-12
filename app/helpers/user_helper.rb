module UserHelper
  def gravatar_for user, options = {size: Settings.size_avatar}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def check_admin? user
    current_user.admin? && !current_user?(user)
  end
end
