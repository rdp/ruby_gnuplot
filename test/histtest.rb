require '../lib/gnuplot'

Gnuplot.open do |gp|
    gp << "bin(x, s) = s*int(x/s)\n"

    Gnuplot::Plot.new( gp ) do |plot|
	plot.title  "Histogram"
	plot.xlabel "x"
	plot.ylabel "frequency"

	x = (0..500).collect { |v| (rand()-0.5)**3 }
	plot.data << Gnuplot::DataSet.new( [x] ) do |ds|
	    ds.title = "smooth frequency" 
	    ds.using = "(bin($1,.01)):(1.)"
	    ds.smooth = "freq"
	    ds.with = "boxes"
	end
    end
end

