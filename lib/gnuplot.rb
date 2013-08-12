# Methods and variables for interacting with the gnuplot process.  Most of
# these methods are for sending data to a gnuplot process, not for reading from
# it.  Most of the methods are implemented as added methods to the built in
# classes.

require 'matrix'
require 'gnuplot/array'
require 'gnuplot/matrix'
require 'gnuplot/dataset'
require 'gnuplot/plot'
require 'gnuplot/splot'

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
end
