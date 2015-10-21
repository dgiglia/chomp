module ApplicationHelper
  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end
  
  def display_datetime(date)
    date.strftime("%m/%d/%Y")
  end
  
  def rating_options(selected=nil)
    options_for_select((1..5).map { |rating| [pluralize(rating, "Bite"), rating]}, selected)
  end
  
  def latest_chomp(obj)
    return "N/A" if obj.reviews.empty?
    display_datetime(obj.reviews.last.created_at)
  end
end
