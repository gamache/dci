rules = <<-EOT
  rule number
    '-'? ( [0-9]+ '.' [0-9]*  /  '.'? [0-9]+ ) 
    ([eE] [-+]? [0-9]+)? {
      def is_number
        true
      end
    }
  end

  rule space
    ' ' / "\t" / "\n"
  end

  rule string
    '"' (!'"' . / '\' '"')* '"'
  end

  rule token
    (
      number   { def is_number; true; end  }
      /
      command  { def is_command; true; end }
      /
      string   { def is_string; true; end  }
    )
    { def is_token; true; end }
  end

  rule line
    (space* token)* space*
  end

EOT

rules += "rule command\n" +
         DCI.cmds.
             map(&:to_s).
             sort{|a,b| b.length <=> a.length}.
             map{|cmd| "'#{cmd}'"}.
             join(' / ') +
         "\nend\n"

Treetop.load_from_string("grammar DCIGrammar\n#{rules}\nend")


