module Kernel
  def __DIRNAME__
    File.dirname(File.expand_path(caller.first.match(/^(.*?):/)[1]))
  end
  
  #require_relative

  alias_method :rrequire, :require_relative
end

class String
  def /(name)
    self + "/" + name
  end
end