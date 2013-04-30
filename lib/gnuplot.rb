# Methods and variables for interacting with the gnuplot process.  Most of
# these methods are for sending data to a gnuplot process, not for reading from
# it.  Most of the methods are implemented as added methods to the built in 
# classes.

require 'matrix'
 
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
  
    
    
  # Holds command information and performs the formatting of that command
  # information to a Gnuplot process.  When constructing a new plot for
  # gnuplot, this is the first object that must be instantiated.  On this
  # object set the various properties and add data sets.

  class Plot
    attr_accessor :cmd, :data, :settings

    QUOTED = [ "title", "output", "xlabel", "x2label", "ylabel", "y2label", "clabel", "cblabel", "zlabel" ]

    def initialize (io = nil, cmd = "plot")
      @cmd = cmd
      @settings = []
      @arbitrary_lines = []
      @data = []
      @styles = []
      yield self if block_given?
      puts "writing this to gnuplot:\n" + to_gplot + "\n" if $VERBOSE

      if io    
        io << to_gplot
        io << store_datasets
      end
    end
    attr_accessor :arbitrary_lines

    # Invoke the set method on the plot using the name of the invoked method
    # as the set variable and any arguments that have been passed as the
    # value. See the +set+ method for more details.

    def method_missing( methId, *args )
      set methId.id2name, *args
    end


    # Set a variable to the given value.  +Var+ must be a gnuplot variable and
    # +value+ must be the value to set it to.  Automatic quoting will be
    # performed if the variable requires it.  
    #
    # This is overloaded by the +method_missing+ method so see that for more
    # readable code.

    def set ( var, value = "" )
      value = "\"#{value}\"" if QUOTED.include? var unless value =~ /^'.*'$/
      @settings << [ :set, var, value ]
    end

    # Unset a variable. +Var+ must be a gnuplot variable.
    def unset ( var )
        @settings << [ :unset, var ]
    end


    # Return the current value of the variable.  This will return the setting
    # that is currently in the instance, not one that's been given to a
    # gnuplot process.

    def [] ( var )
      v = @settings.rassoc( var )
      if v.nil? or v.first == :unset
          nil
      else
          v[2]
      end
    end

    class Style
      attr_accessor :linestyle, :linetype, :linewidth, :linecolor,
        :pointtype, :pointsize, :fill, :index

      alias :ls :linestyle
      alias :lt :linetype
      alias :lw :linewidth
      alias :lc :linecolor
      alias :pt :pointtype
      alias :ps :pointsize
      alias :fs :fill

      alias :ls= :linestyle=
      alias :lt= :linetype=
      alias :lw= :linewidth=
      alias :lc= :linecolor=
      alias :pt= :pointtype=
      alias :ps= :pointsize=
      alias :fs= :fill=

      STYLES = [:ls, :lt, :lw, :lc, :pt, :ps, :fs]

      def Style.increment_index
        @index ||= 0
        @index += 1

        @index
      end

      def initialize
        STYLES.each do |s|
          send("#{s}=", nil)
        end
        yield self if block_given?

        # only set the index if the user didn't do it
        @index = Style::increment_index if index.nil?
      end

      def to_s
        str = "set style line #{index}"
        STYLES.each do |s|
          style = send(s)
          if not style.nil?
            str << " #{s} #{style}"
          end
        end

        str
      end
    end

    # Create a gnuplot linestyle
    def style &blk
      s = Style.new &blk
      @styles << s
      s
    end

    def add_data ( ds )
      @data << ds
    end


    def to_gplot (io = "")
      @settings.each do |setting|
          io << setting.map(&:to_s).join(" ") << "\n"
      end
      @styles.each{|s| io << s.to_s << "\n"}
      @arbitrary_lines.each{|line| io << line << "\n" }

      io
    end

    def store_datasets (io = "")
      if @data.size > 0
        io << @cmd << " " << @data.collect { |e| e.plot_args }.join(", ")
        io << "\n"

        v = @data.collect { |ds| ds.to_gplot }
      	io << v.compact.join("e\n")
      end
      
      io
    end
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
