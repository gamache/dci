class DCI
  def parser; self.class.parser; end
  def self.parser
    @@parser ||= RDParser.new do |g|
      g.line    'term(s?) optional_space'
      g.term    'optional_space atom'
      g.atom    'number | string | command'
      g.number  %r{(
                    -?                          # optional negative sign
                    (?: \d+ \. \d* | \.? \d+ )  # mantissa
                    (?: [eE] [-+]? \d+)?        # optional exponent
                )}x
      g.string  %r{(
                    (?: ' (?: \\ ' | [^'])* ' ) |
                    (?: " (?: \\ " | [^"])* " )
                )}x
      g.command Regexp.new cmds.map(&:to_s).
                                sort{|a,b| b.length <=> a.length}.
                                map{|cmd| Regexp.quote(cmd)}.
                                join('|')
      g.optional_space /\s*/
    end
  end
end

