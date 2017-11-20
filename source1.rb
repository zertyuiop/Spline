class Spline
  require 'spliner'
  require 'pp'
my_spline = Spliner::Spliner.new [-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1], [1, 1,1,1, 0, -1, -1, -1, -1]
for i in 1..100
  puts my_spline[(-1.0 + 2.0/100 * (i-1))]
end
end


matt = Matrix[mat.to_a]
bb = Vector[b.transpose.to_a]
c = NMatrix.ones(2)
matt = Matrix[c.to_a]
bb = Vector[1.0,2.0]