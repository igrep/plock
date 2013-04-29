require 'plock'
require 'stringio'

describe Plock do
  describe '.inspect_block ' do
    subject do
      a = 1
      described_class.inspect_block { a + 1 }
    end
    it { should eq ['(a + 1)', 2] }
  end
  describe '.format' do
    context 'when Plock.output_format = "%b #=> %r"' do
      subject { described_class.format '(a + 1)', 2 }
      it { should eq '(a + 1) #=> 2' }
      it 'never changes the output_format desructively' do
        described_class.output_format = '%b and %r SHOULD NOT BE CHANGED'
        described_class.format 'block', 'result'
        described_class.output_format.should eq '%b and %r SHOULD NOT BE CHANGED'
      end
    end
  end
end

RSpec::Matchers.define :include_when_ignoring_space_difference do|expected|
  match do|actual|
    expected.gsub( /\s+/, '' ).include? actual.gsub( /\s+/, '' )
  end
end

describe Kernel do
  describe '#p' do
    before( :all ) { $stdin = StringIO.new '', 'wb' } # replaces the stdin for testing the output of p
    subject { p { 1 + 1 } }
    it { should be 2 }
    it 'prints out the expression and result onto stdin' do
      $stdin.string.should include_when_ignoring_space_difference '(1 + 1) #=> 2'
    end
    after( :all ) { $stdin = STDIN } # restore default stdin
  end
end
