model Firms
  parameter Real y; //capacidad máxima
  parameter Real c; //costo marginal unitario
  parameter Real lambdaP = 1; //factor crecimiento de precio 
  parameter Real lambdaN = 0.8; //factor decrecimiento de precio 
  parameter Integer firmNumber; 
  Real p; //precio
  Real z; //ventas 
  Real b; //beneficios
  
initial equation 
  p = firmNumber; 
equation
  when sample(2,10) then 
    b = (pre(p)*pre(z)) - (c*pre(z)); 
    if z < y then 
      p = pre(p) - lambdaN; 
    else 
      p = pre(p) + lambdaP; 
    end if; 
  end when; 
  
end Firms;
