class UserDecorator < Draper::Decorator
  delegate_all

  def location
    object.city + ", " + object.state
  end

end