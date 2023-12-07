model System
  parameter Integer n = 10;
  Firm[n] firms;
  Real YY(start = 0);
  
initial equation
  for i in 1:n loop
    firms[i].randomAgentValue = i;
    firms[i].Z = 2*firms[i].U + firms[i].p;
  end for;
  
algorithm
when sample(0,10) then 
  for i in 1:n loop
    YY := YY + firms[i].Y;
  end for;
  
  for i in 1:n loop
    firms[i].YY := YY;
  end for;
end when; 
  
  annotation(
    experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-06, Interval = 20));
end System;
