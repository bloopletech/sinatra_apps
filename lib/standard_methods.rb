module Kernel
  def h(str)
    Rack::Utils.escape_html(str)
  end
end