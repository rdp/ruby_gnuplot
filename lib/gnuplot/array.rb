module Gnuplot
  module Array
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
		if self.size == 2
			f = to_gsplot2d()
		else
			f = to_gsplot3d()
		end
      elsif ( self[0].kind_of? Numeric ) then
     	self.length.times do |i| f << "#{self[i]}\n" end
      else
        self[0].zip( *self[1..-1] ).to_gsplot
      end
      f
    end
	private
	def to_gsplot2d
	    f = ""
        x = self[0]
        y = self[1]
        x.each_with_index do |xv, i|
			yv = y[ i ]
            f << [ xv, yv, 0 ].join(" ") << "\n"
        end
		f
	end
	def to_gsplot3d
	  f = ""
      x = self[0]
      y = self[1]
      d = self[2]
	  type = self[3]

	  if ( type == :points )
	      x.each_with_index do |xv, i|
       	      f << [ xv, y[i], d[i] ].join(" ") << "\n"
		  end		
	  else
	      x.each_with_index do |xv, i|
    	      y.each_with_index do |yv, j|
        	      f << [ xv, yv, d[i][j] ].join(" ") << "\n"
       	   end
      	    f << "\n"
      	end
	  end
	  f
	end
  end
end

Array.send(:include, Gnuplot::Array)
