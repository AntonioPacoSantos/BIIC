model Connected_Godley_table 
Modelica.Blocks.Interfaces.RealOutput Treasury(start = 0);
Modelica.Blocks.Interfaces.RealOutput TBonds_B(start = 294);
Modelica.Blocks.Interfaces.RealOutput Loans_CBT(start = 486);
Modelica.Blocks.Interfaces.RealOutput Treasury_E(start = -780);
Modelica.Blocks.Interfaces.RealInput Int_BB;
Modelica.Blocks.Interfaces.RealInput Tax;
Modelica.Blocks.Interfaces.RealInput Spend;
Modelica.Blocks.Interfaces.RealInput Bonds_B;
Modelica.Blocks.Interfaces.RealInput Loant_Int;
equation 
der(Treasury) = (-Spend) + (Tax) + (Bonds_B) + (-Int_BB) + (Loant_Int); 
der(TBonds_B) = (Bonds_B); 
der(Loans_CBT) = (Loant_Int); 
der(Treasury_E) = (-Spend) + (Tax) + (-Int_BB); 
end Connected_Godley_table; 
