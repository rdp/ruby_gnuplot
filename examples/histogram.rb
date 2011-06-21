$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require "gnuplot"
Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
  
    plot.title  "Histogram example"
    plot.style  "data histograms"
    plot.xtics  "nomirror rotate by -45"
    
    titles = %w{decade Austria Hungary  Belgium} 
    data = [
      ["1891-1900",  234081,  181288,  18167],    
      ["1901-1910",  668209,  808511,  41635],   
      ["1911-1920",  453649,  442693,  33746],   
      ["1921-1930",  32868,   30680,   15846],    
      ["1931-1940",  3563,    7861,    4817],     
      ["1941-1950",  24860,   3469,    12189],   
      ["1951-1960",  67106,   36637,   18575],  
      ["1961-1970",  20621,   5401,    9192],
    ]
    
    x = data.collect{|arr| arr.first}
    (1..3).each do |col|  
      y = data.collect{|arr| arr[col]}
      plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
        ds.using = "2:xtic(1)"
        ds.title = titles[col]
      end
    end
  
  end
end