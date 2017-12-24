class Utils
  def self.image_path_for(file_name)
    File.join(Dir.pwd, "images/#{file_name}.png")
  end
end
