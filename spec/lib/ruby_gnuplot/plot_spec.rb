describe Gnuplot::Plot do
  subject(:plot) { described_class.new }

  describe '#to_gplot' do
    context 'when nothing has been set' do
      it "returns an empty string" do
        expect(plot.to_gplot).to eq('')
      end
    end

    context 'when titles and labels have been set' do
      let(:expected_string) do
        [
          'set title "Array Plot Example"',
          'set ylabel "x"',
          'set xlabel "x^2"',
          ''
        ].join("\n")
      end

      before do
        plot.title  "Array Plot Example"
        plot.ylabel "x"
        plot.xlabel "x^2"
      end

      it "sets title and axis labels" do
        expect(plot.to_gplot).to eq(expected_string)
      end
    end
  end
end
