require 'sourcify'
require "plock/version"

module Plock
  def self.inspect_block &block
    result = block.call
    "#{ block.to_source( attached_to: __method__, strip_enclosure: true ) } #=> #{result.inspect}"
  end
end
