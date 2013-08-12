require 'matrix'

module Gnuplot
  module Matrix
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
end
