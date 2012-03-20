require "gnuplot"

Gnuplot.open do |gp|
  Gnuplot::SPlot.new( gp ) do |plot|
    plot.grid

    plot.data = [
      Gnuplot::DataSet.new( "x**2+y**2" ) do |ds|
    	ds.with = "pm3d"
      end
    ]
  end
end
