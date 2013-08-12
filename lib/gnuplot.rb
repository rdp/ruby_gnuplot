# Methods and variables for interacting with the gnuplot process.  Most of
# these methods are for sending data to a gnuplot process, not for reading from
# it.  Most of the methods are implemented as added methods to the built in
# classes.

require 'matrix'
require 'gnuplot/plot'

module Gnuplot

  # Trivial implementation of the which command that uses the PATH environment
  # variable to attempt to find the given application.  The application must
  # be executable and reside in one of the directories in the PATH environment
  # to be found.  The first match that is found will be returned.
  #
  # bin [String] The name of the executable to search for.
  #
  # Return the full path to the first match or nil if no match is found.
  #
  def Gnuplot.which ( bin )
    if RUBY_PLATFORM =~ /mswin|mingw/
      all = [bin, bin + '.exe']
    else
      all = [bin]
    end
    for exec in all
      if which_helper(exec)
        return which_helper(exec)
      end
    end
    return nil
  end

  def Gnuplot.which_helper bin
    return bin if File::executable? bin

    path = ENV['PATH']
    path.split(File::PATH_SEPARATOR).each do |dir|
      candidate = File::join dir, bin.strip
      return candidate if File::executable? candidate
    end

    # This is an implementation that works when the which command is
    # available.
    #
    # IO.popen("which #{bin}") { |io| return io.readline.chomp }

    return nil
  end

  # Find the path to the gnuplot executable.  The name of the executable can
  # be specified using the RB_GNUPLOT environment variable but will default to
  # the command 'gnuplot'.
  #
  # persist [bool] Add the persist flag to the gnuplot executable
  #
  # Return the path to the gnuplot executable or nil if one cannot be found.
  def Gnuplot.gnuplot( persist = true )
    exe_loc = which( ENV['RB_GNUPLOT'] || 'gnuplot' )
    raise 'gnuplot executable not found on path' unless exe_loc
    cmd = '"' + exe_loc + '"'
    cmd += " -persist" if persist
    cmd
  end

  # Open a gnuplot process that exists in the current PATH.  If the persist
  # flag is true then the -persist flag is added to the command line.  The
  # path to the gnuplot executable is determined using the 'which' command.
  #
  # See the gnuplot documentation for information on the persist flag.
  #
  # <b>todo</b> Add a method to pass the gnuplot path to the function.

  def Gnuplot.open( persist=true )
    cmd = Gnuplot.gnuplot( persist )
    IO::popen( cmd, "w+") { |io|
      yield io
      io.close_write
      @output = io.read
    }
    return @output
  end

  # Analogous to Plot class, holds command information and performs the formatting of that command
  # information to a Gnuplot process. Should be used when for drawing 3D plots.

  class SPlot < Plot

    def initialize (io = nil, cmd = "splot")
      super
    end

    # Currently using the implementation from parent class Plot.
    # Leaving the method explicit here, though, as to allow an specific
    # implementation for SPlot in the future.
    def to_gplot (io = "")
      super
    end

  end


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

  class DataSet
    attr_accessor :title, :with, :using, :data, :linewidth, :linecolor, :matrix, :smooth, :axes, :index, :linestyle

    alias :ls :linestyle
    alias :ls= :linestyle=

    def initialize (data = nil)
      @data = data
      @linestyle = @title = @with = @using = @linewidth = @linecolor = @matrix =
          @smooth = @axes = @index = nil # avoid warnings
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
      io << " linecolor #{@linecolor}" if @linecolor
      io << " linewidth #{@linewidth}" if @linewidth
      io << " linestyle #{@linestyle.index}" if @linestyle
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

class Array
  def to_gplot
    if ( self[0].kind_of? Array ) then
      tmp = self[0].zip( *self[1..-1] )
      tmp.collect { |a| a.join(" ") }.join("\n") + "\ne"
    elsif ( self[0].kind_of? Numeric ) then
      s = ""
      self.length.times { |i| s << "#{self[i]}\n" }
      s
    else
      self[0].zip( *self[1..-1] ).to_gplot
    end
  end

  def to_gsplot
    f = ""

    if ( self[0].kind_of? Array ) then
      x = self[0]
      y = self[1]
      d = self[2]

      x.each_with_index do |xv, i|
        y.each_with_index do |yv, j|
          f << [ xv, yv, d[i][j] ].join(" ") << "\n"
        end
        # f << "\n"
      end
    elsif ( self[0].kind_of? Numeric ) then
      self.length.times do |i| f << "#{self[i]}\n" end
    else
      self[0].zip( *self[1..-1] ).to_gsplot
    end

    f
  end
end

class Matrix
  def to_gplot (x = nil, y = nil)
    xgrid = x || (0...self.column_size).to_a
    ygrid = y || (0...self.row_size).to_a

    f = ""
    ygrid.length.times do |j|
      y = ygrid[j]
      xgrid.length.times do |i|
        if ( self[j,i] ) then
          f << "#{xgrid[i]} #{y} #{self[j,i]}\n"
        end
      end
    end

    f
  end

end
