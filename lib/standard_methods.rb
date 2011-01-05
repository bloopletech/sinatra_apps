module Kernel
  def h(str)
    Rack::Utils.escape_html(str)
  end
end

class File
  def self.escape_name(filename)
    filename.gsub(/([ \[\]\(\)'"&!\\])/) { |r| "\\#{$1}" }
  end
end