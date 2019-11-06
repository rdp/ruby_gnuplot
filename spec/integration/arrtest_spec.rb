describe "Array Plot Example" do
  let(:file_path)    { 'spec/tmp/array_plot.eps' }
  let(:fixture_path) { 'spec/fixtures/plots/array_plot.eps' }

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

        plot.title  "Array Plot Example"
        plot.ylabel "x"
        plot.xlabel "x^2"
        plot.set    "term","postscript eps"
        plot.set    "out", "'#{path}'"

        x = (0..50).collect { |v| v.to_f }
        y = x.collect { |v| v ** 2 }

        plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
          ds.with = "linespoints"
          ds.notitle
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
