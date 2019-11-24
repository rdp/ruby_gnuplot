describe Gnuplot::Plot do
  subject(:plot) { described_class.new }

  describe '#to_gplot' do
    let(:expected_string) do
      [
        'set title "Array Plot Example"',
        'set ylabel "x"',
        'set xlabel "x^2"',
        'set term postscript eps',
        'set output "file.eps"',
        ''
      ].join("\n")
    end


    context 'when nothing has been set' do
      it "returns an empty string" do
        expect(plot.to_gplot).to eq('')
      end
    end

    context 'when titles and labels have been set' do
      before do
        plot.title  "Array Plot Example"
        plot.ylabel "x"
        plot.xlabel "x^2"
        plot.term   "postscript eps"
        plot.output "file.eps"
      end

      it "wraps strings with quotes when needed" do
        expect(plot.to_gplot).to eq(expected_string)
      end
    end

    context 'when variables are set throgh set call' do
      before do
        plot.set "title",  "Array Plot Example"
        plot.set "ylabel", "x"
        plot.set "xlabel", "x^2"
        plot.set "term",   "postscript eps"
        plot.set "output", "file.eps"
      end

      it "wraps strings with quotes when needed" do
        expect(plot.to_gplot).to eq(expected_string)
      end
    end

    context "when setting from inside initialization" do
      subject(:plot) do
        described_class.new do |p|
          p.title  "Array Plot Example"
          p.ylabel "x"
          p.xlabel "x^2"
          p.term   "postscript eps"
          p.output "file.eps"
        end
      end

      it "wraps strings with quotes when needed" do
        expect(plot.to_gplot).to eq(expected_string)
      end
    end
  end
end
