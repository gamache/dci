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

require 'treetop'

require 'dci/commands'
require 'dci/grammar'

class DCI

  attr_accessor :stack
  attr_accessor :regs
  attr_accessor :prefs
  attr_accessor :history
  attr_accessor :output
  attr_accessor :parser

  def initialize(prefs_hash={})
    self.stack = []
    self.regs = {}
    self.history = []
    self.output = []

    self.prefs = {
      :precision => 4,
      :display_mode => :auto,
      :degrad => :deg
    }.merge(prefs_hash)

    self.parser = DCIGrammarParser.new
    self.parser.root = 'line'
  end


  def do(line)
    do_line(line)
  end

  def do_line(line)
    do_tokens(tokenize_line(line))
    true
  rescue ParseError => e
    output << e.message
    false
  end

  def do_tokens(tokens)
    tokens.each do |tok|
      tok_str = tok.text_value.gsub(/(^\s+|\s+$)/,'')

      if tok.respond_to?(:is_command)
        begin
          self.send("_cmd_#{tok_str}".to_sym)
        rescue ArgumentError => e
          output.push "Error at '#{tok_str}': #{e.message}.  Ignoring rest of line."
          return
        end

      elsif tok.respond_to?(:is_string)
        stack.push eval(tok_str)

      elsif tok.respond_to?(:is_number)
        stack.push tok_str.to_f

      else
        raise RuntimeError, "Unrecognized token node: #{tok.inspect}"
      end

      history.push tok_str
    end
  end

  def tokenize_line(line)
    def get_tokens_under_node(node)
      nodes = []
      nodes << node if node.respond_to?(:is_token)
      nodes << node.elements.map{|n| get_tokens_under_node(n)} if node.elements
      nodes.flatten
    end

    node = parser.parse(line)

    if !node
      raise ParseError, "Error parsing line: '#{line}'.  Line ignored."
    else
      return get_tokens_under_node(node)
    end
  end





end

class ParseError < Exception
end

