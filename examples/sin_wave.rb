$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require "gnuplot"
Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
  
    plot.xrange "[-10:10]"
    plot.title  "Sin Wave Example"
    plot.ylabel "sin(x)"
    plot.xlabel "x"
    
    plot.data << Gnuplot::DataSet.new( "sin(x)" ) do |ds|
      ds.with = "lines"
      ds.linewidth = 4
    end
    
  end
  sleep 10
end