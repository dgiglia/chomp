class BusinessDecorator < Draper::Decorator
  delegate_all
  def overall_rating
    object.average_rating.present? ? "#{object.average_rating} / 5 bites" : 0
  end 
  
  def location
    object.city + ", " + object.state
  end
  
  def avatar
    object.business_photo.present? ? object.business_photo : "face_icons/shop.png"
  end
  
  def website
    h.link_to_if object.url, h.fix_url(object.url), h.fix_url(object.url)
  end
end