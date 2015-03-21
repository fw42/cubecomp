path = File.expand_path("../themes/", __FILE__)

def subdirectories(path)
  dirs = []

  Dir.entries(path).each do |sub_dir|
    sub_path = "#{path}/#{sub_dir}"
    next unless File.directory?(sub_path)
    next if [".", ".."].include?(sub_dir)
    dirs << sub_path
  end

  dirs
end

def files_in_directory(path)
  files = []

  Dir.entries(path).each do |filename|
    file_path = "#{path}/#{filename}"
    next unless File.file?(file_path)
    files << file_path
  end

  files
end

def new_theme_file(path)
  filename = path.split('/').last

  theme_file = ThemeFile.new
  theme_file.filename = filename

  if filename =~ /(\.jpg|\.png|\.gif)\z/
    theme_file.image = File.open(path)
  else
    theme_file.content = File.read(path)
  end

  theme_file
end

subdirectories(path).each do |theme_path|
  theme_name = theme_path.split('/').last
  variants = subdirectories(theme_path).map{ |path| path.split('/').last }
  variants = [''] if variants.empty?

  variants.each do |variant|
    theme = Theme.new
    theme.name = variant.present? ? "#{theme_name} #{variant}" : "#{theme_name}"

    files_in_directory(theme_path).each do |file_path|
      theme.files << new_theme_file(file_path)
    end

    if variant != ''
      files_in_directory("#{theme_path}/#{variant}").each do |file_path|
        theme.files << new_theme_file(file_path)
      end
    end

    puts "New theme #{theme.name}: #{theme.files.size} files"
    theme.save!
  end
end
