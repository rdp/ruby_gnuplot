require '../lib/gnuplot'

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
  
    plot.title  "Array Plot Example"
    plot.ylabel "x"
    plot.xlabel "x^2"
    
    x = (0..50).collect { |v| v.to_f }
    y = x.collect { |v| v ** 2 }

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "linespoints"
      ds.notitle
    end
    
  end
  
end
    
