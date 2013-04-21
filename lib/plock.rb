require 'sourcify'
require "plock/version"

module Plock
  def self.inspect_block &block
    result = block.call
    "#{ block.to_raw_source( attached_to: __method__ ) } #=> #{result.inspect}"
  end
end
