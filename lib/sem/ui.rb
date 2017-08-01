module Sem::UI
  module_function

  def strong(message)
    "\e[32m#{message}\e[0m"
  end

  def info(message)
    puts message
  end

  def list(items)
    items.each do |item|
      info "  #{item}"
    end
  end

  def table(rows)
    list_items = rows.map do |row|
      row.join(" ")
    end

    list(list_items)
  end

end
