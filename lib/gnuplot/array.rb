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
end

Array.send(:include, Gnuplot::Array)
