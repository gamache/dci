class DCI
  def self.cmds
    @@cmds.keys
  end

  def self.defcmd(name, argc=0, type=nil, &block)
    @@cmds ||= {}
    @@cmds[name.to_sym] = true

    define_method("_cmd_#{name}".to_sym) do
      unless argc <= stack.length
        raise ArgumentError, 
          "Error in #{name}: Too few values on stack (#{argc} required, #{stack.length} present)"
      end
      if type
        stack[-argc, argc].each do |arg|
          unless arg.is_a?(type)
            raise ArgumentError, "Error in #{name}: All arguments must be of type #{type}"
          end
        end
      end
      instance_eval(&block)
    end
  end

  def self.aliascmd(new_name, old_name)
    @@cmds[new_name.to_sym] = true
    self.send(:alias_method,"_cmd_#{new_name}".to_sym, "_cmd_#{old_name}".to_sym)
  end

  def self.convert_angle_to_rads(angle)
    return angle if prefs[:degrad] == :rad
    return angle*Math::PI/180
  end

  def self.convert_angle_from_rads(angle)
    return angle*180/Math::PI if prefs[:degrad] == :deg
    return angle
  end


  ## control commands: q _ ?

  # quit
  defcmd :q do
    self.stopped = true
  end

  # no-op
  defcmd '_' do
  end

  # input
  defcmd '?' do
    puts "? "
    stack.push gets.gsub(/\s*$/,'')
  end


  ## arithmetic commands: + - * / ^ %,mod v,sqrt V !,fact

  defcmd '+', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push(a + b)
  end

  defcmd '-', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push(a - b)
  end

  defcmd '*', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push(a * b)
  end

  defcmd '/', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push(a / b)
  end

  defcmd '^', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push(a**b)
  end

  defcmd '%', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push(a % b)
  end
  aliascmd 'mod', '%'

  defcmd 'v', 1, Numeric do
    a = stack.pop
    stack.push Math.sqrt(a)
  end
  aliascmd 'sqrt', 'v'

  defcmd 'V', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push a**(1/b)
  end

  defcmd '!', 1, Numeric do
    def fact(n, acc=1); n>1 ? fact(n-1, acc*n) : acc; end
    stack.push fact(stack.pop.to_i.abs)
  end
  aliascmd 'fact', '!'


  ## stack commands: c d r

  defcmd 'c' do
    stack.pop while stack.length>0
  end

  defcmd 'd', 1 do
    stack.push stack.last
  end

  defcmd 'r', 2 do
    b = stack.pop
    a = stack.pop
    stack.push b
    stack.push a
  end


  ## printing commands: p n f

  defcmd 'p', 1 do
    output.push stack.last
  end

  defcmd 'n', 1 do
    output.push stack.pop
  end

  defcmd 'f' do
    output.push stack.shift while stack.length > 0
  end


  ## logs and e: ln log exp e

  defcmd 'ln', 1, Numeric do
    stack.push Math.log(stack.pop)
  end

  defcmd 'log', 1, Numeric do
    stack.push Math.log10(stack.pop)
  end

  defcmd 'exp', 1, Numeric do
    stack.push Math::E**stack.pop
  end

  defcmd 'e' do
    stack.push Math::E
  end


  ## rec, neg, abs, int

  defcmd 'rec', 1, Numeric do
    stack.push 1/stack.pop
  end

  defcmd 'neg', 1, Numeric do
    stack.push 0-stack.pop
  end

  defcmd 'abs', 1, Numeric do
    stack.push stack.pop.abs
  end

  defcmd 'int', 1, Numeric do
    stack.push stack.pop.to_i
  end


  ## trigonometry: pi sin cos tan asin acos atan

  defcmd 'pi' do
    stack.push Math::PI
  end

  ['sin', 'cos', 'tan', 'sinh', 'cosh', 'tanh'].each do |op|
    defcmd op, 1, Numeric do
      stack.push Math.send(op.to_sym, convert_angle_to_rads(stack.pop))
    end

    defcmd "a#{op}", 1, Numeric do
      stack.push convert_angle_from_rads(Math.send("a#{op}".to_sym, stack.pop))
    end
  end

  defcmd 'atan2', 2, Numeric do
    b = stack.pop
    a = stack.pop
    stack.push convert_angle_from_rads(Math.atan(a, b))
  end


  ## complex value conversion: pol rect

  defcmd 'pol', 2, Numeric do
    x = stack.pop
    y = stack.pop
    stack.push convert_angle_from_rads(Math.atan(y, x)) # theta
    stack.push Math.sqrt(x*x + y*y)                     # r
  end

  defcmd 'rect', 2, Numeric do
    r     = stack.pop
    theta = convert_angle_to_rads(stack.pop)
    stack.push r*Math.cos(theta) # y
    stack.push r*Math.sin(theta) # x
  end


  ## output mode commands: k K 

  defcmd 'k', 1, Numeric do
    prefs[:precision] = stack.pop.to_i.abs
  end

  defcmd 'K' do
    stack.push prefs[:precision]
  end



  defcmd 'auto' do
    prefs[:dispmode] = :auto
  end

  defcmd 'sci' do
    prefs[:dispmode] = :sci
  end

  defcmd 'eng' do
    prefs[:dispmode] = :eng
  end

end
