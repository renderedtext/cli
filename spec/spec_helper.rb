require "bundler/setup"
require "byebug"
require "sem"
require "simplecov"
require "webmock/rspec"

require_relative "support/coverage"
require_relative "support/factories"
require_relative "support/web_stubs"
require_relative "support/api_response"
require_relative "support/io_stub"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/.bundle/"
end

def sem_run(args)
  stdout, stderr, _, status = IOStub.collect_output do
    Sem.start(args.split(" "))
  end

  [stdout, stderr, status]
end

def sem_run!(args)
  stdout, stderr, status = sem_run(args)

  raise "Non Zero Exit Status" if status != :ok

  [stdout, stderr]
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.include WebStubs

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # test coverage percentage only if the whole suite was executed
  unless config.files_to_run.one?
    config.after(:suite) do
      example_group = RSpec.describe("Code coverage")

      example_group.example("must be 100%") do
        coverage = SimpleCov.result
        percentage = coverage.covered_percent

        Support::Coverage.display(coverage)

        expect(percentage).to eq(100)
      end

      # quickfix to resolve weird behaviour in rspec
      raise "coverage is too low" unless example_group.run(RSpec.configuration.reporter)
    end
  end

end
