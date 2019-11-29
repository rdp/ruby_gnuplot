describe "Multtest Plot Example" do
  let(:file_path)    { 'spec/tmp/multtest_plot.eps' }
  let(:fixture_path) { 'spec/fixtures/plots/multtest_plot.eps' }

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

        x = (0..50).collect(&:to_f)
        y = x.collect { |v| v**2 }

        plot.data = [
          Gnuplot::DataSet.new( "sin(x)" ) do |ds|
            ds.with = "lines"
            ds.title = "String function"
            ds.linewidth = 4
          end,

          Gnuplot::DataSet.new( [x, y] ) do |ds|
            ds.with = "linespoints"
            ds.title = "Array data"
          end
        ]
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
