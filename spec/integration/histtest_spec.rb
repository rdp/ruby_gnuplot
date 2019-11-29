describe "Histogram Plot Example" do
  let(:file_path)    { 'spec/tmp/histogram_plot.eps' }
  let(:fixture_path) { 'spec/fixtures/plots/histogram_plot.eps' }

  let(:file_content) do
    File.read(file_path).gsub(/CreationDate.*/, "")
  end

  let(:fixture_content) do
    File.read(fixture_path).gsub(/CreationDate.*/, "")
  end

  before do
    path = file_path
    RandomGenerator.seed(0.17)

    collection = (0..500).collect do
      (RandomGenerator.rand - 0.5)**3
    end

    Gnuplot.open do |gp|
      gp << "bin(x, s) = s*int(x/s)\n"

      Gnuplot::Plot.new( gp ) do |plot|
        plot.title  "Histogram"
        plot.xlabel "x"
        plot.ylabel "frequency"

        plot.data << Gnuplot::DataSet.new( [collection] ) do |ds|
          ds.title = "smooth frequency"
          ds.using = "(bin($1,.01)):(1.)"
          ds.smooth = "freq"
          ds.with = "boxes"
        end

        plot.term   "postscript eps"
        plot.output path
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
