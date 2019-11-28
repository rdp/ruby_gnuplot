require 'spec_helper'

describe Gnuplot::DataSet do
  subject(:data_set) { described_class.new(data) }

  let(:data) { nil }

  describe '#to_gplot' do
    context 'when data is an empty array' do
      let(:data) { [] }

      it do
        expect(data_set.to_gplot).to eq('')
      end
    end

    context 'when data is an array of numbers' do
      let(:data) { [1, 10.0, 2.3] }

      it 'converts to gplot format' do
        expect(data_set.to_gplot).to eq("1\n10.0\n2.3")
      end
    end

    context 'when data is a matrix of numbers' do
      let(:data) { [[1, 10.0], [0, 2]] }

      it 'converts to gplot matrix format' do
        expect(data_set.to_gplot).to eq("1 0\n10.0 2\ne")
      end
    end

    context 'when data is a string' do
      let(:data) { 'x' }

      it do
        expect(data_set.to_gplot).to be_nil
      end
    end

    context 'when data is an instance of Matrix' do
      xit 'to be implemented'
    end

    context 'when data is nil' do
      it do
        expect(data_set.to_gplot).to be_nil
      end

      it 'assigns data' do
        expect(data_set.data).to eq(data)
      end
    end

    context 'when setting attributes' do
      subject(:data_set) do
        described_class.new do |ds|
          ds.with  = 'lines'
          ds.using = '1:2'
          ds.data = [ [0, 1, 2], [1, 2, 5] ]
        end
      end

      it 'returns only the data' do
        expect(data_set.to_gplot)
          .to eq("0 1\n1 2\n2 5\ne")
      end
    end
  end
end
