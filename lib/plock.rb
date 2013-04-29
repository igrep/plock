require 'sourcify'
require 'pp'

require "plock/version"

module Plock
  module Format
    PERCENT_B = '%b'.freeze
    PERCENT_R = '%r'.freeze
    DEFAULT_FORMAT = "#{PERCENT_B} #=> #{PERCENT_R}".freeze
  end

  class << self
    attr_writer :output_format
    def output_format
      @output_format ||= self::Format::DEFAULT_FORMAT
    end

    def inspect_block( attached = :inspect_block, &block )
      result = block.call
      [ block.to_source( attached_to: attached, strip_enclosure: true ), result ]
    end

    def print_block_with formatter_method, attached, *args, &block
      returned = []
      returned.concat args

      block_source, block_result = Plock.inspect_block( attached, &block )

      puts self.__send__( formatter_method, block_source, block_result )

      returned << block_result
      returned.length > 1 ? returned : returned.first
    end

    def format_with block_source, block_result, inspect_method
      result = self.output_format.dup
      result.sub! self::Format::PERCENT_B, block_source
      result.sub! self::Format::PERCENT_R, block_result.__send__( inspect_method )
      return result
    end

    def format block_source, block_result
      self.format_with block_source, block_result, :inspect
    end

    if Object.public_method_defined? :pretty_inspect
      def pretty_format block_source, block_result
        self.format_with block_source, block_result, :pretty_inspect
      end
    end
  end

end

module Kernel # reopen
  alias p_without_plock p
  def p_with_plock *args, &block
    if block_given?
      Plock.print_block_with :format, :p, *args, &block
    else
      p_without_plock( *args )
    end
  end
  alias p p_with_plock

  if Kernel.private_method_defined? :pp
    alias pp_without_plock pp
    def pp_with_plock
      if block_given?
        Plock.print_block_with :pretty_format, :pp, *args, &block
      else
        pp_without_plock( *args )
      end
    end
    alias pp pp_with_plock
  end
end
