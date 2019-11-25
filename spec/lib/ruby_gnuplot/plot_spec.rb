shared_examples 'quotes value when setting in a plot for' do |field|
  describe "##{field}" do
    before do
      plot.public_send(field, 'text')
    end

    it 'quotes value when setting it' do
      expect(plot.to_gplot).to eq("set #{field} \"text\"\n")
    end

    it 'enquees into settings' do
      expect { plot.public_send(field, 'new text') }
        .to change(plot, :settings)
        .from([[:set, field.to_s, '"text"']])
        .to([
          [:set, field.to_s, '"text"'],
          [:set, field.to_s, '"new text"']
      ])
    end
  end
end

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

  it_behaves_like 'quotes value when setting in a plot for', :title
  it_behaves_like 'quotes value when setting in a plot for', :output
  it_behaves_like 'quotes value when setting in a plot for', :xlabel
  it_behaves_like 'quotes value when setting in a plot for', :x2label
  it_behaves_like 'quotes value when setting in a plot for', :ylabel
  it_behaves_like 'quotes value when setting in a plot for', :y2label
  it_behaves_like 'quotes value when setting in a plot for', :clabel
  it_behaves_like 'quotes value when setting in a plot for', :cblabel
  it_behaves_like 'quotes value when setting in a plot for', :zlabel

  describe '#unset' do
    let(:expected_string) do
      [
        'set title "My Title"',
        'unset title',
        ''
      ].join("\n")
    end

    before do
      plot.title 'My Title'
    end

    # TODO: check specification
    xit 'changes value in current settings' do
      expect { plot.unset 'title' }
        .to change { plot['title'] }
        .from('My title').to(nil)
    end

    it 'unsets key on output' do
      plot.unset 'title'
      expect(plot.to_gplot).to eq(expected_string)
    end
  end

  describe '#[]' do
    context 'when value was never set' do
      it { expect(plot['key']).to be_nil }
    end

    context 'when value was only unset' do
      before { plot.unset 'title' }

      it { expect(plot['title']).to be_nil }
    end

    context 'when value was set only once' do
      before { plot.title "My Title" }

      it "returns the value to be used (quoted when needed)" do
        expect(plot['title']).to eq('"My Title"')
      end
    end

    context 'when value was set twice' do
      before do
        plot.title "My Title"
        plot.title "My New Title"
      end

      # TODO: check specification
      xit "returns the last value set" do
        expect(plot['title']).to eq('"My New Title"')
      end
    end

    context 'when value was set then unset' do
      before do
        plot.title "My Title"
        plot.unset "title"
      end

      # TODO: check specification
      xit { expect(plot['title']).to be_nil }
    end

    context 'when value was set, unset and set again' do
      before do
        plot.title "My Title"
        plot.unset "title"
        plot.title "My New Title"
      end

      # TODO: check specification
      xit "returns the last value set" do
        expect(plot['title']).to eq('"My New Title"')
      end
    end
  end

  describe 'method missing' do
    it 'delegates to set call' do
      expect { plot.fake_field('value') }
        .to change(plot, :settings)
        .from([])
        .to([[:set, 'fake_field', 'value']])
    end

    context 'when field should be quoted' do
      it 'delegates to set call and quote it' do
        expect { plot.output('value') }
          .to change(plot, :settings)
          .from([])
          .to([[:set, 'output', '"value"']])
      end
    end
  end
end
