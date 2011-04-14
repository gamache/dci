##  dci
##
##  AN RPN SCIENTIFIC CALCULATOR FOR CONSOLE USERS;
##  /usr/bin/dc Improved for Engineers;
##  six hundred one.
##
##  copyright 2006-2011  pete gamache  gamache@!#$!@#gmail.com
##
##  DCI is released free of charge under the MIT License (included as
##  LICENSE.txt), and is available at http://github.com/gamache/dci/.

$LOAD_PATH.unshift(File.dirname(__FILE__))

#require 'treetop'
require 'rdparser'

require 'dci/commands'
require 'dci/grammar'


class DCI

  attr_accessor :stack
  attr_accessor :regs
  attr_accessor :prefs
  attr_accessor :history
  attr_accessor :output
  attr_accessor :stopped

  def initialize(prefs_hash={})
    self.stack = []
    self.regs = {}
    self.history = []
    self.output = []
    self.stopped = false
    self.prefs = {
      :precision => 4,
      :display_mode => :auto,
      :degrad => :rad
    }.merge(prefs_hash)
  end

  def repl
    self.stopped = false
    while !self.stopped
      line = gets
      begin
        do_line(line)
      rescue Exception => e
        puts e.message
      end
    end
  end

  def do(line)
    do_line(line)
  end

private

  def do_line(line)
    do_tokens(tokenize_line(line))
    true
  rescue ParseError => e
    output << e.message
    false
  end

  def do_tokens(tokens)
    tokens.each do |tok|
      if tok.has_key?(:number)
        stack.push tok[:number].to_f
      elsif tok.has_key?(:string)
        stack.push eval(tok[:string])
      elsif tok.has_key?(:command)
        self.send("_cmd_#{tok[:command]}".to_sym)
        emit_output(output.shift) while output.length > 0
      else
        raise ParseError, "Unrecognized token: #{tok.inspect}"
      end
    end
  end

  def tokenize_line(line)
    tokens = []
    tree = parser.parse(:line, line)
    tree.each do |node|
      if node[:term]
        tokens << node[:term][1][:atom][0]
      end
    end
    tokens
  end

  def emit_output(val)
    if val.is_a?(Numeric)
      if prefs[:dispmode] == :sci
        printf "%.#{prefs[:precision]}E\n", val
      elsif prefs[:dispmode] == :eng
        ## TODO -- for now, just use scientific
        printf "%.#{prefs[:precision]}E\n", val
      elsif prefs[:dispmode] == :fix
        printf "%.#{prefs[:precision]}f\n", val
      else
        printf "%G\n", val
      end
    else
      puts val
    end
  end

end


class ParseError < Exception
end

