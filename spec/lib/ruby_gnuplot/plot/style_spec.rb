describe Gnuplot::Plot::Style do
  subject(:style) { described_class.new }

  let(:index) { style.index }

  describe '#to_s' do
    context "when nothing has been set" do
      it 'creates an empty style' do
        expect(style.to_s).to eq("set style line #{index}")
      end
    end

    context 'when setting the stype' do
      before do
        style.ls = 1
        style.lw = 2
        style.lc = 3
        style.pt = 4
        style.ps = 5
        style.fs = 6
      end

      it 'creates and indexes the style' do
        expect(style.to_s).to eq(
          "set style line #{index} ls 1 lw 2 lc 3 pt 4 ps 5 fs 6"
        )
      end
    end

    context 'when setting the stype on initialize' do
      subject(:style) do
        described_class.new do |style|
          style.ls = 1
          style.lw = 2
          style.lc = 3
          style.pt = 4
          style.ps = 5
          style.fs = 6
        end
      end

      it 'creates and indexes the style' do
        expect(style.to_s).to eq(
          "set style line #{index} ls 1 lw 2 lc 3 pt 4 ps 5 fs 6"
        )
      end
    end

    context 'when setting using the full method name' do
      before do
        style.linestyle = 1
        style.linewidth = 2
        style.linecolor = 3
        style.pointtype = 4
        style.pointsize = 5
        style.fill      = 6
      end

      it 'creates and indexes the style' do
        expect(style.to_s).to eq(
          "set style line #{index} ls 1 lw 2 lc 3 pt 4 ps 5 fs 6"
        )
      end
    end
  end
end
