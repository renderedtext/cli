module Sem
  class Views
    require_relative "views/base"

    Dir["lib/sem/views/**/*.rb"].each { |f| require_relative f.gsub(%r{^lib/sem/}, "") }
  end
end
