model connected_godley_table 
Modelica.Blocks.Interfaces.RealOutput Vault(start = 99);
Modelica.Blocks.Interfaces.RealOutput Loans(start = 0);
Modelica.Blocks.Interfaces.RealOutput Firms(start = 0);
Modelica.Blocks.Interfaces.RealOutput Safe(start = 0);
Modelica.Blocks.Interfaces.RealInput FirmInt;
Modelica.Blocks.Interfaces.RealInput Loan;
Modelica.Blocks.Interfaces.RealInput IntLoan;
equation 
der(Vault) = (-Loan); 
der(Loans) = (Loan) + (IntLoan) + (-IntLoan); 
der(Firms) = (Loan) + (-IntLoan) + (FirmInt); 
der(Safe) = (IntLoan) + (-FirmInt); 
end connected_godley_table; 
