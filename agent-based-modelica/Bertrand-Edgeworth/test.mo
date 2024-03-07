model DiscreteAlgebraicLoop
  Real a(start = 2); 
  Real b(start = 5); 
  Real c(start = 8);
  
equation
  a = 2*b; 
  b = 2*c; 
  c = 2*a;
end DiscreteAlgebraicLoop;
