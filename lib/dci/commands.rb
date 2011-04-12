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
          "Too few values on stack (#{argc} required, #{stack.length} present)"
      end
      if type
        stack[-argc, argc].each do |arg|
          unless arg.is_a?(type)
            raise ArgumentError, "All arguments must be of type #{type}"
          end
        end
      end
      instance_eval(&block)
    end
  end

  defcmd :+, 2, Numeric do
    a = stack.pop
    b = stack.pop
    stack.push(a + b)
  end

  defcmd :f do
    stack.each {|val| output.push val}
  end

  defcmd :fff, 0 do
    stack.push "LOL"
  end
end
