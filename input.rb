require 'io/console'
class Input
  def initialize
    Signal.trap("INT") do # SIGINT = control-C
      exit
    end
  end

  def get
    system("stty raw -echo")
    c = STDIN.read_nonblock(1) rescue ""
    system("stty -raw echo")
    c
  end
end