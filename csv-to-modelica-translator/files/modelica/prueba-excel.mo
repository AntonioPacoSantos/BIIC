model Godley_table 
output Real Treasury(start = 0);
output Real TBonds_B(start = 294);
output Real Loans_CBT(start = 486);
output Real Treasury_E(start = -780);
input Real Loant_Int;
input Real Bonds_B;
input Real Spend;
input Real Int_BB;
input Real Tax;
equation 
der(Treasury) = (-Spend) + (Tax) + (Bonds_B) + (-Int_BB) + (Loant_Int); 
der(TBonds_B) = (Bonds_B); 
der(Loans_CBT) = (Loant_Int); 
der(Treasury_E) = (-Spend) + (Tax) + (-Int_BB); 
end godley_table; 
