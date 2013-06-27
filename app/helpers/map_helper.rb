module MapHelper

  def static_map_for(user_visits)
    params = {
      center: "isle of Man, United Kingdom",
      zoom: 5,
      size: "300x300"
      }

    query_string = params.map{|k,v| "#{k}=#{v}"}.join("&")

    markers = ""
    user_visits.each do |visit|
      markers += "&markers=color:green%7Clabel:G%7C#{visit.latitude},#{visit.longitude}"
    end

    image_tag "http://maps.googleapis.com/maps/api/staticmap?#{query_string}#{markers}&sensor=false"
  end
end
