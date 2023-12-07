model Godley_table 
output Real Vault(start = 99);
output Real Loans(start = 0);
output Real Firms(start = 0);
output Real Safe(start = 0);
input Real IntLoan;
input Real FirmInt;
input Real Loan;
equation 
der(Vault) = (-Loan); 
der(Loans) = (Loan) + (IntLoan) + (-IntLoan); 
der(Firms) = (Loan) + (-IntLoan) + (FirmInt); 
der(Safe) = (IntLoan) + (-FirmInt); 
end godley_table; 
