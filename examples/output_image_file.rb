$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require "gnuplot"

# See sin_wave.rb first
Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
  
    # The following lines allow outputting the graph to an image file. 
    # The first set the kind of image that you want, while the second
    # redirects the output to a given file. 
    #
    # Typical terminals: gif, png, postscript, latex, texdraw
    #
    # See http://mibai.tec.u-ryukyu.ac.jp/~oshiro/Doc/gnuplot_primer/gptermcmp.html
    # for a list of recognized terminals.
    #
    plot.terminal "gif"
    plot.output File.expand_path("../sin_wave.gif", __FILE__)
  
    # see sin_wave.rb
    plot.xrange "[-10:10]"
    plot.title  "Sin Wave Example"
    plot.ylabel "sin(x)"
    plot.xlabel "x"
    
    plot.data << Gnuplot::DataSet.new( "sin(x)" ) do |ds|
      ds.with = "lines"
      ds.linewidth = 4
    end
    
  end
end
puts 'created sin_wave.gif'
