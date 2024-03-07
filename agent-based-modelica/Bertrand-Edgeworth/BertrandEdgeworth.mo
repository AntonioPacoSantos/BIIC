package BertrandEdgeworth
model BertrandEdgeworthModel
  inner parameter Real M = 3;
  //demanda agregada
  parameter Integer N = 2;
  //cantidad de firmas
  inner parameter Real c = 1;
  //costo marginal unitario
  inner parameter Real y = 10;
  //oferta
  output Real[N] P(start = {i for i in 1:N});
  //precios
  Firms[N] F;
  //firmas
  output Real[N] Z(start = {0 for i in 1:N});
  //cantidades vendidas

initial equation
  for i in 1:N loop
    F[i].p = P[i];
  end for;
  
equation
  when sample(1, 10) then
    //Z = buyingProcess(N);
    Z = buyingProcess(N,M,y);
    for i in 1:N loop 
      F[i].z = Z[i]; 
    end for; 
  end when;
  
  when sample(3, 10) then
    P = {F[i].p for i in 1:N};
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
end BertrandEdgeworthModel;
model Firms
  outer parameter Real y; //capacidad máxima
  outer parameter Real c; //costo marginal unitario
  parameter Real lambdaP = 1; //factor crecimiento de precio
  parameter Real lambdaN = 0.8; //factor decrecimiento de precio
  Real p; //precio
  Real z(start = 0); //ventas
  Real b(start = 0);   //beneficios

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
  
  function buyingProcess
    //input Real[:] P;
    input Integer N; 
    input Real M; 
    input Real y; 
    output Real[:] X; 
    protected Real tempSpent; 
    protected Real tempMinPrice; 
    protected Real tempFirmChosen; 
    
    
    
   
  algorithm 
      X := {0 for i in 1:N}; 
      
      
      tempSpent := M; 
      tempMinPrice := max(P); 
      while tempSpent > 0 loop 
        tempFirmChosen := N + 1; 
        for i in 1:N loop 
          if P[i] <= tempMinPrice and X[i] <= y and tempSpent - P[i] >= 0 then 
            tempMinPrice := P[i]; 
            tempFirmChosen := i; 
          end if; 
        end for; 
        if tempFirmChosen == N + 1 then 
          break;
        else 
          tempSpent := tempSpent - tempMinPrice; 
          X[tempFirmChosen] := X[tempFirmChosen] + 1; 
        end if; 
      end while;
      
  
  end buyingProcess;

end BertrandEdgeworth;
