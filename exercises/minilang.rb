require 'pry'

class MinilangError < StandardError; end

class Minilang
  ACTIONS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(command_string)
    @commands = command_string.split
  end

  def eval
    @register = 0
    @stack = []
    @commands.each do |command|
      eval_command(command)
    end
  rescue MinilangError => error
    puts error.message
  end

  private

  def eval_command(command)
    if ACTIONS.include?(command)
      send(command.downcase)
    elsif command.to_i.to_s == command
      self.register = command.to_i
    else
      raise MinilangError, "Invalid token: #{command}"
    end
  end

  def push
    @stack.push(@register)
  end

  def add
    @register += pop_stack
  end

  def sub
    @register -= pop_stack
  end

  def mult
    @register *= pop_stack
  end

  def div
    @register /= pop_stack
  end

  def mod
    @register %= pop_stack
  end

  def pop
    @register = pop_stack
  end

  def pop_stack
    raise MinilangError, 'Empty stack!' if @stack.empty?

    @stack.pop
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

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
