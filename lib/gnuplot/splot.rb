module Gnuplot
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
end
