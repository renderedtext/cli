module Sem
  module UI
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
      table = Terminal::Table.new(:rows => rows)
      table.style = { :border_top => false, :border_bottom => false, :border_y => " " }

      puts table
    end

  end
end
