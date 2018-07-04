class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_limit => [150, 150]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}_#{file.extension}" if original_filename.present?
  end

  def size_range
    1..5.megabytes
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
