require 'sourcify'
require 'pp'

require "plock/version"

module Plock
  module Format
    PERCENT_B = '%b'.freeze
    PERCENT_R = '%r'.freeze
    DEFAULT_FORMAT = "#{PERCENT_B} #=> #{PERCENT_R}"
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

    def print_block( printer, pprinter, attached = :print_block, *args, &block )
      returned = []

      __send__( pprinter, *args )
      returned.concat args

      block_source, block_result = Plock.inspect_block( attached, &block )
      __send__( printer, block_source )
      __send__( pprinter, block_result )
      returned << block_result

      returned.length > 1 ? returned : returned.first
    end

    def format block_source, block_result
      result = self.output_format.dup
      result.sub! self::Format::PERCENT_B, block_source
      result.sub! self::Format::PERCENT_R, block_result.inspect
      return result
    end
  end

end

module Kernel # reopen
  alias p_without_plock p
  def p_with_plock *args, &block
    Plock.print_block( :puts, :p_without_plock, :p, *args, &block )
  end
  alias p p_with_plock

  alias pp_without_plock pp
  def pp_with_plock
    Plock.print_block( :puts, :pp_without_plock, :pp, *args, &block )
  end
  alias pp pp_with_plock
end
