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
  describe '.format_with' do
    context 'when Plock.output_format = "%b #=> %r"' do
      before { described_class.output_format = "%b #=> %r" }
      subject { described_class.format_with :inspect, '(a + 1)', 2 }
      it { should eq '(a + 1) #=> 2' }
      it 'never changes the output_format desructively' do
        described_class.output_format = '%b and %r SHOULD NOT BE CHANGED'
        described_class.format_with :inspect, 'block', 'result'
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

RSpec::Matchers.define :equals_when_ignoring_space_difference do|expected|
  match do|actual|
    expected.gsub( /\s+/, '' ) == actual.gsub( /\s+/, '' )
  end
end

describe Kernel do
  describe '#p' do
    before { $stdout = StringIO.new '', 'wb' } # replaces the stdin for testing the output of p
    after { $stdout = STDOUT } # restore default stdin

    context 'when Plock.output_format = "%b #=> %r"' do
      before( :all ) { Plock.output_format = "%b #=> %r" }
      let( :no_percent ){ Plock.output_format.gsub( /%[br]/, '' ) }

      subject { p { 1 + 1 } }
      before { subject }

      it { should be 2 }
      it "prints out the block and the block's result onto stdin" do
        $stdout.string.should include_when_ignoring_space_difference "(1 + 1) #{no_percent} 2"
      end

      context 'given both argument and block' do
        subject { p( 'one plus one' ) { 1 + 1 } }

        it { should be 2 }
        it 'prints out its arguments, its block, and the result onto stdin' do
          $stdout.string.should equals_when_ignoring_space_difference %Q'"one plus one" (1 + 1) #{no_percent} 2'
        end
      end

    end

  end
end
