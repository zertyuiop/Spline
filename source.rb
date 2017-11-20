class Spline
  require 'nmatrix/nmatrix'
  require 'pp'
  require 'gnuplotrb'
  include GnuplotRB
  DH1, DH2, DH3, DP0, DPn, X0, Xn = 10, 50, 100, 0, 0, -1, 1
  def self.funct(x)
    funct = -x/x.abs
  end
  def self.coefficients(dh, x0, xn, dp0=0, dpn=0)
    mat = NMatrix.zeros((dh * 2) * 4)
    for i in 1..dh*2
      for j in 1..4
        mat[2 * (i - 1), (i - 1) * 4 + j - 1] = (x0 + 1.0 / dh * (i - 1)) ** (4 - j)
        mat[2 * (i - 1) + 1, (i - 1) * 4 + j - 1] = (x0 + 1.0 / dh * i) ** (4 - j)
      end
    end
    for i in 0..2
      mat[dh * 2 * 2, i] = (3 - i) * x0 ** (2 - i)
      mat[dh * 2 * 2 + 1, dh * 2 * 4 - 4 + i] = (3 - i) * xn ** (2 - i)
    end
    for i in 1..dh*2-1
      for j in 1..3
        mat[dh * 2 * 2 + 2 + 2 * (i - 1), (i-1)*4+(j-1)]= (4-j) * (x0 + 1.0 / dh * (i)) ** (3 - j)
        mat[dh * 2 * 2 + 2 + 2 * (i - 1), (i-1)*4+(j-1) + 4]= -(4-j) * (x0 + 1.0 / dh * (i)) ** (3 - j)
      end
      for j in 1..2
        mat[dh * 2 * 2 + 2 + 2 * (i - 1)+1, (i-1)*4+(j-1)]= (4-j) * (4-j-1) * (x0 + 1.0 / dh * (i)) ** (2 - j)
        mat[dh * 2 * 2 + 2 + 2 * (i - 1)+1, (i-1)*4+(j-1) + 4]= -(4-j) * (4-j-1) * (x0 + 1.0 / dh * (i)) ** (2 - j)
      end
    end
    b = NMatrix.zeros([((dh * 2) * 4), 1])
    for i in 1..dh*2
      b[2*(i-1), 0] = (x0 + 1.0 / dh * (i - 1) == 0)? 0 : funct(x0 + 1.0 / dh * (i - 1))
      b[2*(i-1)+1, 0] = (x0 + 1.0 / dh * (i) == 0)? 0 : funct(x0 + 1.0 / dh * (i))
    end
    b[dh*4] = dp0
    b[dh*4+1] = dpn
    x = mat.solve(b)
    a = Array.new
    b = (-1.0..1.0).step(1.0/dh/10).to_a
    c = Array.new
    b.each{|k| c.push(k == 0? 0:-k/k.abs)}
    for k in 1..dh*2

    for i in 1..10
      a.push(x[0+(k-1)*4]*(x0 + (i-1) * 1.0/dh/10 + (k-1) * 1.0/dh)**3+x[1+(k-1)*4]*(x0 + (i-1) * 1.0/dh/10 + (k-1) * 1.0/dh)**2+x[2+(k-1)*4] *(x0 + (i-1) * 1.0/dh/10 + (k-1) * 1.0/dh)+x[3+(k-1)*4])
    end
    end
    simple_plot = Plot.new(
        [[b,a], with: 'lines', lt: { rgb: 'blue', lw: 3 }],
        [[b,c], with: 'lines', lt: { rgb: 'red', lw: 3 }]
    )
    simple_plot.to_png('plot'+dh.to_s+'.png')
    return a
  end
  coefficients(DH1, X0, Xn, DP0, DPn)
  coefficients(DH2, X0, Xn, DP0, DPn)
  coefficients(DH3, X0, Xn, DP0, DPn)
end