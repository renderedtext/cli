module Sem::UI
  module_function

  def strong(message)
    "\e[31m;#{message}\e[0m"
  end

  def info(message)
    puts message
  end

  def list(items)
    items.each do |item|
      info "  #{item}"
    end
  end

end
