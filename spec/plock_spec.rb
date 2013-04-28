require 'plock'

describe Plock do
  describe '.inspect_block ' do
    subject do
      a = 1
      described_class.inspect_block { a + 1 }
    end
    it { should eq ['(a + 1)', 2] }
  end
  describe '.format' do
    context 'Plock.output_format = "%b #=> %r"'
    subject { described_class.format '(a + 1)', 2 }
    it { should eq '(a + 1) #=> 2' }
  end
end

describe Kernel do
  describe '#p' do
    subject { p { 1 + 1 } }
    it { should be 2 }
    it 'calls Plock.inspect_block' do
      Plock.should_receive :inspect_block
      p { 1 + 1 }
    end
  end
end
