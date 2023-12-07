model Connected_Godley_table 
Modelica.Blocks.Interfaces.RealOutput Bank(start = 6.0);
Modelica.Blocks.Interfaces.RealOutput Firms(start = 7.0);
Modelica.Blocks.Interfaces.RealOutput Workers(start = 8.0);
equation 
der(Bank) = (-5.0) + (0.0); 
der(Firms) = (5.0) + (-2.0); 
der(Workers) = (nan) + (2.0); 
end Connected_Godley_table; 
