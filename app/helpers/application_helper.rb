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
  def gravatar_for(user, size = :small)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)

    case size
      when :small
        size    = 50
        width   = 50
        height  = 50
      else
        size    = 150
        width   = 150
        height  = 150
    end
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm&r=pg"
    image_tag(gravatar_url, alt: user.full_name, width: width, height: height)
  end

end
