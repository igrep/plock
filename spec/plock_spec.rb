require 'plock'

describe Plock do
  describe '.inspect ' do
    subject { described_class.inspect_block { 1 + 1 } }
    it { should eq '1 + 1 #=> 2' }
  end
  describe '#p' do
    subject { p { 1 + 1 } }
    it { should be 2 }
    it 'calls Plock.inspect' do
      Plock.should_receive :inspect
      p { 1 + 1 }
    end
  end
end
