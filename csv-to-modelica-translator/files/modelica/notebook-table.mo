model Godley_table 
output Real  Loans(start = 110);
output Real Firms(start = 90);
output Real Workers(start = 10);
output Real Banks(start = 10);
input Real Interest_F;
input Real Consume_W;
input Real Wages;
input Real Lend_F;
input Real Repay_F;
input Real Buy_B;
equation 
der( Loans) = (Lend_F) + (-Repay_F); 
der(Firms) = (Lend_F) + (-Interest_F) + (-Repay_F) + (-Wages) + (Consume_W) + (Buy_B); 
der(Workers) = (Wages) + (-Consume_W); 
der(Banks) = (Interest_F) + (-Buy_B); 
end Godley_table; 
