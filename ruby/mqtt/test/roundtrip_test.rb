require "minitest/autorun"
require "pty"
require "timeout"

# Runs the worker and the publisher as a reader would. The worker runs in a
# pseudo-terminal, so it prints each line straight away
class RoundtripTest < Minitest::Test
  def test_worker_receives_published_message
    Dir.chdir(File.expand_path("..", __dir__)) do
      PTY.spawn("ruby", "worker.rb") do |output, _input, pid|
        Timeout.timeout(10) do
          output.gets until $_&.include?("Waiting for messages")
          system("ruby", "publisher.rb", exception: true)
          output.gets until $_&.include?("Received")
        end
        assert_includes $_, "Hello world!"
      ensure
        Process.kill("TERM", pid)
      end
    end
  end
end
