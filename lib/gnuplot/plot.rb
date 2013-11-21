module Gnuplot
  # Holds command information and performs the formatting of that command
  # information to a Gnuplot process.  When constructing a new plot for
  # gnuplot, this is the first object that must be instantiated.  On this
  # object set the various properties and add data sets.

  class Plot
    attr_accessor :cmd, :data, :settings

    QUOTED = %w(title output xlabel x2label ylabel y2label clabel cblabel zlabel)

    def initialize (io = nil, cmd = "plot")
      @cmd             = cmd
      @settings        = []
      @arbitrary_lines = []
      @data            = []
      @styles          = []
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
end
