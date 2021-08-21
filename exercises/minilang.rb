require 'pry'

class MinilangError < StandardError; end

class Minilang
  ACTIONS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(command_string)
    @command_string = command_string
  end

  def eval(options= nil)
    formatted_commands = format(@command_string, options)
    @register = 0
    @stack = []
    formatted_commands.split.each do |command|
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

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

CENTIGRADE_TO_FAHRENHEIT =
  '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(degrees_c: 100)
# 212
minilang.eval(degrees_c: 0)
# 32
minilang.eval(degrees_c: -40)
# -40
