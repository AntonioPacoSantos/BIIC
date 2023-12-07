model Monte_Carlo_Simulation
parameter Integer iterations = 1; 
ABM_Riccetti.Riccetti_model[iterations] simulations;  
Real Y(start = 0); 
initial algorithm 
  for k in 1:iterations loop 
    simulations[k].i := k; 
  end for; 
equation
  Y = sum(simulations.AggregateY)/iterations;

annotation(
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-6, Interval = 2));
end Monte_Carlo_Simulation;