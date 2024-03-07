function buyingProcess
  input Real[:] P; 
  input Integer N; 
  input Real M; 
  input Real y; 
  output Real[:] Z; 
  protected Real tempSpent; 
  protected Real tempMinPrice; 
  protected Real tempFirmChosen; 
  
algorithm
    Z := {0 for i in 1:N}; 
    tempSpent := M; 
    tempMinPrice := max(P); 
    while tempSpent > 0 loop 
      tempFirmChosen := N + 1; 
      for i in 1:N loop 
        if P[i] <= tempMinPrice and Z[i] <= y and tempSpent - P[i] >= 0 then 
          tempMinPrice := P[i]; 
          tempFirmChosen := i; 
        end if; 
      end for; 
      if tempFirmChosen == N + 1 then 
        break;
      else 
        tempSpent := tempSpent - tempMinPrice; 
        Z[tempFirmChosen] := Z[tempFirmChosen] + 1; 
      end if; 
    end while;

end buyingProcess;
