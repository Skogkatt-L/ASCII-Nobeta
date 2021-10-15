require 'rainbow/refinement'
require 'mini_magick'
class NobetaController < ApplicationController
  using Rainbow
  def index
    @ascii_art = ""
    if (!params[:file_upload].nil?)

    else
      logger.debug "=> Loading ASCII Nobeta".color(:blueviolet)
      @ascii_art = default_ascii_art
    end
  end

  def nobeta
    @ascii_art = ""
    @ascii_raw = ""
    # Check the file field is nil or not
    if (!params[:file_upload].nil?)
      # If the file is not nil, get the file
      file = params[:file_upload]
      logger.debug "=> Loading File from: #{file.path}".green
      logger.debug "=> Origin File Name: #{file.original_filename}".green
      logger.debug "=> Content Type / MIME: #{file.content_type}".green
      # Checking the file size
      if (File.size(file) <= (1048576*3))
        # Checking the file type
        if file.content_type.eql?"text/plain"
          # If it is text file
          logger.debug "=> Detect Text File: #{file.content_type}".color(:aqua)
          logger.debug "=> Reading File: #{file.path}".color(:aqua)
          tmpStr = txt_to_str(file.open)
          @ascii_art = str_to_html(tmpStr)
          @ascii_art += "<br /><br /><h1>Here is your ASCII Art.</h1>"
          @ascii_raw = str_to_raw(tmpStr)
        elsif file.content_type.match?(/image/)
          # If it is image file
          logger.debug "=> Detect Image File: #{file.content_type}".color(:aqua)
          logger.debug "=> Detect Color Mode: #{params[:colour_mode]}".color(:aqua)
          logger.debug "=> Reading File: #{file.path}".color(:aqua)
          tmpStr = img_to_str(file.open, params[:colour_mode], params[:inverse].to_b)
          @ascii_art = str_to_html(tmpStr)
          @ascii_art += "<br /><br /><h1>Here is your ASCII Art.</h1>"
          @ascii_raw = str_to_raw(tmpStr)
        else
          # If it is other types of file
          logger.error "=> Detect Content Type Imcompatible: #{file.content_type}".red
          @ascii_art = error_ascii_art
          @ascii_art += "<br /><br /><h1>Imcompatible File.</h1>"
          @ascii_raw = "error"
        end
      else
        # File size larger than 3 MB
        logger.error "=> Detect File Size Larger than 3 MB: #{file.content_type}".red
        @ascii_art = error_ascii_art
        @ascii_art += "<br /><br /><h1>File size is larger than 3 MB.</h1>"
        @ascii_raw = "error"
      end
      # Close the file
      file.close
      logger.debug "=> Close File: #{file.path}".color(:aqua)
    else
      # No File Uploaded
      logger.error "=> No File Uploaded!".red
      @ascii_art = error_ascii_art
      @ascii_art += "<br /><br /><h1>No File Uploaded!</h1>"
      @ascii_raw = "error"
    end
  end

  def file_download
    # Check the hidden field
    if params[:ascii_raw].eql? "default"
      path = "#{Rails.root}/public/text/"
      file_name = "ASCII-nobeta-480.txt"
      tempfile = File.open("#{path}#{file_name}")
    elsif params[:ascii_raw].eql? "error"
      path = "#{Rails.root}/public/text/"
      file_name = "ASCII-nobeta2-480.txt"
      tempfile = File.open("#{path}#{file_name}")
    else
      str_array = params[:ascii_raw].split(/\r\n/)
      tempfile = str_to_txt(str_array)
    end
    logger.debug "=> File Download: #{tempfile.path}".color(:aqua)
    logger.debug "===> tempfile size (download): #{tempfile.size}".green
    send_file(tempfile, :filename => "ASCII_#{SecureRandom.urlsafe_base64}.txt", :type => "text/plain", :disposition => "attachment")
    tempfile.close
  end

  # Private Method
  private
  # Convert Text File into String Array
  def txt_to_str(txt_file)
    logger.debug "===> Converting Text File: ".green + txt_file.path.color(:aqua) + " into String Array".green
    return txt_file.to_a
  end
  # Convert Image File into String Array
  def img_to_str(img_file, colour_mode, inverse)
    logger.debug "===> Converting Image File: ".green + img_file.path.color(:aqua) + " into String Array".green
    # Initial ASCII character and String Array
    ascii_str = " `.^,:;Il!i~+_-?][}{1)(|/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$".reverse
    str_array = []
    if inverse
      ascii_str.reverse!
    end
    # Open Image File
    image = MiniMagick::Image.open(img_file)
    logger.debug "===> Image Path: ".green + image.path.color(:aqua)
    # Resize the image
    new_width = 480
    new_height = (0.54*(new_width*image.height/image.width)).ceil
    image.resize new_width.to_s + "x" + new_height.to_s + "!"
    # Get Image Pixels
    pixels = image.get_pixels
    greyscale_pixels = []

    case colour_mode
    when "1"
      greyscale_pixels = rgb_average(pixels)
    when "2"
      greyscale_pixels = rgb_lightness(pixels)
    when "3"
      greyscale_pixels = rgb_lominosity(pixels)
    else
      logger.error "===> Colour mode is not selected.".red
      greyscale_pixels = rgb_average(pixels)
    end
    # Assign an ASCII character according to greyscale value
    greyscale_pixels.each do |row|
      greyscales = ""
      row.each do |greyscale|
        # ASCII character = Greyscale / ( 255 / length of ASCII character set -1 )
        # or = length of ASCII character set -1 * Greyscale / 255
        ascii_value = ((ascii_str.length-1) * greyscale.to_f / (255.to_f)).ceil
        if ascii_value >= ascii_str.length
          greyscales << ascii_str[(ascii_str.length-1)]
        else
          greyscales << ascii_str[ascii_value]
        end
      end
      str_array << greyscales
    end
    return str_array
  end
  # Assign greyscale value according to Average
  # Greyscale = (R + G + B) / 3
  def rgb_average(pixels)
    greyscale_pixels = []
    pixels.each_with_index do |row, i|
      greyscale_pixels << []
      row.each do |column|
        greyscale_pixels[i] << (column[0] + column[1] + column[2]) / 3
      end
    end
    return greyscale_pixels
  end
  # Assign greyscale value according to Lightness
  # Greyscale = max(R,G,B) + min(R,G,B) / 2
  def rgb_lightness(pixels)
    greyscale_pixels = []
    pixels.each_with_index do |row, i|
      greyscale_pixels << []
      row.each do |column|
        greyscale_pixels[i] << column.max + column.min / 2
      end
    end
    return greyscale_pixels
  end
  # Assign greyscale value according to luminosity
  # Greyscale = R0.21 + G0.72 + B0.07
  def rgb_lominosity(pixels)
    greyscale_pixels = []
    pixels.each_with_index do |row, i|
      greyscale_pixels << []
      row.each do |column|
        greyscale_pixels[i] << column[0]*0.21 + column[1]*0.72 + column[2]*0.07
      end
    end
    return greyscale_pixels
  end
  # Convert String Array into raw String
  def str_to_raw(str_array)
    str = ""
    str_array.each_with_index do |line, index|
      # Remove new line character
      line.gsub!(/(\r|\n)+/, "")
      if !index.eql? str_array.length-1
        str << "#{line}\n"
      else
        str << line
      end
    end
    return str
  end
  # Convert String Array into HTML
  def str_to_html(str_array)
    # Initial HTML
    html = ""
    # Add String to HTML
    str_array.each_with_index do |line, index|
      # Use index to check the last line
      # Add line break if it is not the last line
      # Remove new line character
      line.gsub!(/(\r|\n)+/, "")
      if !index.eql? str_array.length-1
        html << "#{line}<br />"
      else
        logger.debug "=====> Reach the last line.".blue
        html << line
      end
    end
    # Return HTML
    return html
  end
  # Convert String Array into Text File
  def str_to_txt(str_array)
    tempfile = Tempfile.new(["",".txt"])
    tempfile.open
    str_array.each_with_index do |line, index|
      line.gsub!(/(\r|\n)+/, "")
      if !index.eql? str_array.length-1
        tempfile << "#{line}\r\n"
        # File.write(tempfile, "#{line}\n", mode: "a")
      else
        tempfile << line
        # File.write(tempfile, line, mode: "a")
      end
    end
    return tempfile
    tempfile.close
  end
  # Set Default ASCII Art
  def default_ascii_art
    logger.debug "===> Setting the default ASCII Art.".green
    # Init file path
    path = "#{Rails.root}/public/text/"
    # Init file name
    file_name = "ASCII-nobeta-480.txt"
    # Open the file with file name
    logger.debug "===> Reading file from: #{path}#{file_name}".green
    file = File.open("#{path}#{file_name}")
    # Get String from file and return HTML
    return str_to_html(txt_to_str(file))
    # Close the file
    file.close
  end
  # Set Error ASCII Art
  def error_ascii_art
    logger.error "===> Setting the Error ASCII Art.".red
    # Init file path
    path = "#{Rails.root}/public/text/"
    # Init file name
    file_name = "ASCII-nobeta2-480.txt"
    # Open the file with file name
    logger.error "===> Reading file from: #{path}#{file_name}".red
    file = File.open("#{path}#{file_name}")
    # Get String from file and return HTML
    return str_to_html(txt_to_str(file))
    # Close the file
    file.close
  end
  # Add helper
end

class String
  def to_b
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
