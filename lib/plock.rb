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

    def print_block_with inspect_method, attached, &block
      block_source, block_result = Plock.inspect_block( attached, &block )
      puts self.format_with( inspect_method, block_source, block_result )
      block_result
    end

    def format_with inspect_method, block_source, block_result
      result = self.output_format.dup
      result.sub! self::Format::PERCENT_B, block_source
      result.sub! self::Format::PERCENT_R, block_result.__send__( inspect_method )
      return result
    end

  end

end

module Kernel # reopen
  alias p_without_plock p
  def p_with_plock *args, &block
    returned_by_p = p_without_plock( *args )
    if block_given?
      Plock.print_block_with :inspect, :p, &block
    else
      returned_by_p
    end
  end
  alias p p_with_plock

  if Kernel.private_method_defined? :pp
    alias pp_without_plock pp
    def pp_with_plock *args, &block
      returned_by_pp = pp_without_plock( *args )
      if block_given?
        Plock.print_block_with :pretty_inspect, :pp, &block
      else
        returned_by_pp
      end
    end
    alias pp pp_with_plock
  end
end
