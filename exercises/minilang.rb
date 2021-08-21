require 'pry'

class Minilang
  def initialize(command_string)
    @commands = command_string.split
    @register = 0
    @stack = []
  end

  def eval
    @commands.each do |command|
      if command.to_i.to_s == command
        self.register = command.to_i
      else
        send(command.downcase)
      end
    end
  end

  def push
    @stack.push(@register)
  end

  def add
    @register += @stack.pop
  end

  def sub
    @register -= @stack.pop
  end

  def mult
    @register *= @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def pop
    @register = @stack.pop
  end

  def print
    puts @register
  end

  def register=(integer)
    @register = integer
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8
