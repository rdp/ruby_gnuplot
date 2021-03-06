describe "Sin Wave Plot Example" do
  let(:file_path)    { 'spec/tmp/sin_wave_plot.eps' }
  let(:fixture_path) { 'spec/fixtures/plots/sin_wave_plot.eps' }

  let(:file_content) do
    File.read(file_path).gsub(/CreationDate.*/, "")
  end

  let(:fixture_content) do
    File.read(fixture_path).gsub(/CreationDate.*/, "")
  end

  before do
    path = file_path

    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.xrange "[-10:10]"
        plot.title  "Sin Wave Example"
        plot.ylabel "x"
        plot.xlabel "sin(x)"

        plot.term   "postscript eps"
        plot.output path

        plot.data << Gnuplot::DataSet.new( "sin(x)" ) do |ds|
          ds.with = "lines"
          ds.linewidth = 4
        end
      end
    end
  end

  after do
    File.delete(file_path)
  end

  it "plots expected file" do
    expect(file_content).to eq(fixture_content)
  end
end
