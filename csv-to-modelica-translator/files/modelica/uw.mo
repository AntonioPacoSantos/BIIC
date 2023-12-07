model Godley_table 
output Real Firms(start = 0);
output Real Loans(start = 0);
output Real Safe(start = 0);
output Real Vault(start = 100);
output Real Workers(start = 0);
input Real C;
input Real A;
input Real D;
input Real E;
input Real B;
equation 
der(Firms) = (A) + (-B) + (-C) + (D) + (E); 
der(Loans) = (A) + (B) + (-B); 
der(Safe) = (-A) + (-E); 
der(Vault) = (); 
der(Workers) = (C) + (-D); 
end Godley_table; 
