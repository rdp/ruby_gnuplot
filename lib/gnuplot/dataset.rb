module Gnuplot
  # Container for a single dataset being displayed by gnuplot.  Each object
  # has a reference to the actual data being plotted as well as settings that
  # control the "plot" command.  The data object must support the to_gplot
  # command.
  #
  # +data+ The data that will be plotted.  The only requirement is that the
  # object understands the to_gplot method.
  #
  # The following attributes correspond to their related string in the gnuplot
  # command. See the gnuplot documentation for more information on this.
  #
  #   title, with
  #
  # @todo Use the delegator to delegate to the data property.

  module Color
	BLACK = -1
	RED = 1
    GREEN = 2
    BLUE = 3
  end
  module PointType
	DOTTED = 0
	PLUS = 1
	X = 2
	MULTIPLY = 3
	EMPTY_SQUARE = 4
	FILLED_SQUARE = 5
	EMPTY_CIRCLE = 6
	FILLED_CIRCLE = 7
  end

  class DataSet
    attr_accessor :title, :with, :using, :data, :linewidth, :linecolor, :matrix, :smooth, :axes, :index
    attr_accessor :linestyle, :pointtype, :pointsize, :fs, :fc

    alias :ls :linestyle
    alias :ls= :linestyle=

    def initialize (data = nil)
      @data = data
      @linestyle = @title = @with = @using = @linewidth = @linecolor = @pointtype = @pointsize 
          @matrix = @smooth = @axes = @index = @fs = @fc = nil # avoid warnings
      yield self if block_given?
    end

    def notitle
      @title = "notitle"
    end

    def plot_args (io = "")

      # Order of these is important or gnuplot barfs on 'em

      io << ( (@data.instance_of? String) ? @data : "'-'" )

      io << " index #{@index}" if @index

      io << " using #{@using}" if @using

      io << " axes #{@axes}" if @axes

      io << case @title
      when /notitle/ then " notitle"
      when nil       then ""
      else " title '#{@title}'"
      end

      io << " matrix" if @matrix
      io << " smooth #{@smooth}" if @smooth
      io << " with #{@with}" if @with
	  io << " fc #{@fs}" if @fc
	  io << " fs #{@fs}" if @fs
      io << " linecolor #{@linecolor}" if @linecolor
      io << " linewidth #{@linewidth}" if @linewidth
      io << " linestyle #{@linestyle.index}" if @linestyle
	  io << " pointtype #{@pointtype}" if @pointtype
	  io << " pointsize #{@pointsize}" if @pointsize
      io
    end

    def to_gplot
      case @data
      when nil then nil
      when String then nil
      else @data.to_gplot
      end
    end

    def to_gsplot
      case @data
      when nil then nil
      when String then nil
      else @data.to_gsplot
      end
    end

  end
end
