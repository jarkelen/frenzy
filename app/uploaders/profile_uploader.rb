# encoding: utf-8

class ProfileUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/frenzy/#{mounted_as}/#{model.id}"
  end

  # Restrict extensions
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
