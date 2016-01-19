class ReviewPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  process :resize_to_fill => [200, 200]
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  if Rails.env.staging? || Rails.env.production?
    storage :aws
  else
    storage :file
  end

end
