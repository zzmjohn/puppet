require 'puppet/parser/ast/lambda'

Puppet::Parser::Functions::newfunction(
:reject,
:type => :rvalue,
:arity => 2,
:doc => <<-'ENDHEREDOC') do |args|
  Applies a parameterized block to each element in a sequence of entries from the first
  argument and returns an array with the entires for which the block did *not* evaluate to true.

  This function takes two mandatory arguments: the first should be an Array or a Hash, and the second
  a parameterized block as produced by the puppet syntax:

    $a.reject |$x| { ... }

  When the first argument is an Array, the block is called with each entry in turn. When the first argument
  is a hash the entry is an array with `[key, value]`.

  *Examples*

    # selects all that does not end with berry
    $a = ["rasberry", "blueberry", "orange"]
    $a.reject |$x| { $x =~ /berry$/ }

  Since 3.2
  ENDHEREDOC

  receiver = args[0]
  pblock = args[1]

  raise ArgumentError, ("reject(): wrong argument type (#{pblock.class}; must be a parameterized block.") unless pblock.is_a? Puppet::Parser::AST::Lambda

  case receiver
  when Array
  when Hash
  else
    raise ArgumentError, ("reject(): wrong argument type (#{receiver.class}; must be an Array or a Hash.")
  end

  receiver.to_a.reject {|x| pblock.call(self, x) }
end
