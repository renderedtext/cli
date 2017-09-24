require "bundler/setup"
require "byebug"
require "sem"
require "simplecov"
require "webmock/rspec"

require_relative "support/coverage"
require_relative "support/factories"
require_relative "support/web_stubs"
require_relative "support/api_response"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/.bundle/"
end

class IOStub
  attr_reader :data

  def initialize(original_io)
    @original_io = original_io
    @data = ""
  end

  def write(data)
    @data += data
    @original_io.write(data)
  end

  def print(data)
    @data += data
    @original_io.print(data)
  end

  def puts(data)
    @data += data.to_s
    @original_io.puts(data)
  end
end

def collect_output
  original_stdout = $stdout
  original_stderr = $stderr

  $stdout = fake_stdout = IOStub.new($stdout)
  $stderr = fake_stderr = IOStub.new($stderr)

  result = yield

  status = result == 0 ? :ok : :fail

  [fake_stdout.data.to_s, fake_stderr.data.to_s, result, status]
rescue SystemExit
  [fake_stdout.data.to_s, fake_stderr.data.to_s, result, :system_error]
ensure
  $stdout = original_stdout
  $stderr = original_stderr
end

def sem_run(args)
  stdout, stderr, _, status = collect_output do
    Sem.start(args.split(" "))
  end

  [stdout, stderr, status]
end

def sem_run!(args)
  stdout, stderr, status = sem_run(args)

  if status != :ok
    raise "Non Zero Exit Status"
  end

  [stdout, stderr]
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
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
