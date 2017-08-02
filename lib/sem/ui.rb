module Sem
  module UI
    module_function

    def ask(question, options = {})
      print "#{question}: "

      if options[:hidden]
        STDIN.noecho(&:gets).chomp
      else
        STDIN.gets.chomp
      end
    end

    def strong(message)
      "\e[32m#{message}\e[0m"
    end

    def info(message)
      puts message
    end

    def error(message)
      puts message
    end

    def list(items)
      items.each do |item|
        info "  #{item}"
      end
    end

    def table(rows)
      table = Terminal::Table.new(:rows => rows)

      table.style = {
        :border_top => false,
        :border_bottom => false,
        :border_y => "",
        :padding_left => 0,
        :padding_right => 2
      }

      puts table
    end

    def show_hash(hash)
      table(hash.map { |key, value| ["#{key}:", value.to_s] })
    end

  end
end
