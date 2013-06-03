module ApplicationHelper
  # Converts a boolean into a nice text string
  def markup_boolean(boolean_value)
    if boolean_value == true
      I18n.t('.true')
    else
      I18n.t('.false')
    end
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=200&d=mm"
    image_tag(gravatar_url, alt: user.full_name)
  end

end
