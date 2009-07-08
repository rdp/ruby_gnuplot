# -*- ruby -*-

require '../lib/gnuplot'
require 'test/unit'

class StdDataTest < Test::Unit::TestCase
    
  def test_array_1d
    data = (0..5).to_a
    ds = Gnuplot::DataSet.new( data )
    
    assert data, ds.data
    assert data.join("\n") + "\n", ds.to_gplot
  end


  # Test a multidimensional array.

  def test_array_nd
    d1 = (0..3).to_a
    d2 = d1.collect { |v| 3 * v }
    d3 = d2.collect { |v| 4 * v }
    
    data = [ d1, d2, d3 ]
    ds = Gnuplot::DataSet.new( data )
    
    assert data, ds.data
    assert "0 0 0\n1 3 12\n2 6 24\n3 9 36\n", ds.to_gplot
  end
end


class DataSetTest < Test::Unit::TestCase

  def test_yield_ctor
    ds = Gnuplot::DataSet.new do |ds|
      ds.with = "lines" 
      ds.using = "1:2"
      ds.data = [ [0, 1, 2], [1, 2, 5] ]
    end
    
    assert "lines", ds.with
    assert "1:2",   ds.using
    assert nil == ds.title
    assert [ [0, 1, 2], [1, 2, 5] ], ds.data
    assert "'-' using 1:2 with lines",  ds.plot_args
    assert "0 1\n1 2\n2 5\n", ds.to_gplot 
  end
  
end


class PlotTest < Test::Unit::TestCase
  
  def test_no_data
    plot = Gnuplot::Plot.new do |p|
      p.set "output", "'foo'"
      p.set "terminal", "postscript enhanced"
    end

    assert( plot.sets, 
		 [ ["output", "'foo'"], 
		   ["terminal", "postscript enhanced"] ] )
    

    assert( plot.to_gplot, \
		 "set output 'foo'\nset terminal postscript enhanced\n" )

  end

  def test_set
    plot = Gnuplot::Plot.new do |p|
      p.set "title", "foo"
    end
    assert "'foo'", plot["title"]

    plot.set "title", "'foo'"
    assert "'foo'", plot["title"]
  end

end


require 'rbconfig'
CONFIG = Config::MAKEFILE_CONFIG

# This attempts to test the functions that comprise the gnuplot package.  Most
# of the bug reports that I get for this package have to do with finding the
# gnuplot executable under different environments so that makes it difficult
# to test on a single environment.  To try to get around this I'm using the
# rbconfig library and its path to the sh environment variable.

class GnuplotModuleTest

  def test_which
    # Put the spaces around the command to make sure that it gets stripped
    # properly. 
    assert( CONFIG["SHELL"], Gnuplot::which(" sh " ) )
    assert( CONFIG["SHELL"], Gnuplot::which( CONFIG["SHELL"] ) )
  end


  def test_gnuplot
    cmd = Gnuplot.gnuplot
    assert( Gnuplot::which("gnuplot") + " -persist", cmd )

    cmd = Gnuplot.gnuplot(false)
    assert( Gnuplot::which("gnuplot"), cmd )

    # If I set the name of the gnuplot environment variable to a different
    # name (one that is in the path) then I should get the shell name as the
    # result of the gnuplot call.

    ENV["RB_GNUPLOT"] = "sh" 
    assert( CONFIG["SHELL"], Gnuplot.gnuplot(false) )
  end
      
end


