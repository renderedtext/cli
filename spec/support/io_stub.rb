class IOStub
  def self.collect_output
    original_stdout = $stdout
    original_stderr = $stderr

    $stdout = fake_stdout = IOStub.new($stdout)
    $stderr = fake_stderr = IOStub.new($stderr)

    yield

    [fake_stdout.data.to_s, fake_stderr.data.to_s, :ok]
  rescue SystemExit
    [fake_stdout.data.to_s, fake_stderr.data.to_s, :fail]
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  attr_reader :data

  def initialize(original_io)
    @original_io = original_io
    @data = ""
  end

  def tty?
    @original_io.tty?
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
    @data += data.to_s + "\n"
    @original_io.puts(data)
  end
end
