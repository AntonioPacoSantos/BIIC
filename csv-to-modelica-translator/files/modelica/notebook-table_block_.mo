connector Connected_Godley_table 
Modelica.Blocks.Interfaces.RealOutput  Loans(start = 110);
Modelica.Blocks.Interfaces.RealOutput Firms(start = 90);
Modelica.Blocks.Interfaces.RealOutput Workers(start = 10);
Modelica.Blocks.Interfaces.RealOutput Banks(start = 10);
Modelica.Blocks.Interfaces.RealInput Interest_F;
Modelica.Blocks.Interfaces.RealInput Lend_F;
Modelica.Blocks.Interfaces.RealInput Buy_B;
Modelica.Blocks.Interfaces.RealInput Repay_F;
Modelica.Blocks.Interfaces.RealInput Wages;
Modelica.Blocks.Interfaces.RealInput Consume_W;
equation 
der( Loans) = (Lend_F) + (-Repay_F); 
der(Firms) = (Lend_F) + (-Interest_F) + (-Repay_F) + (-Wages) + (Consume_W) + (Buy_B); 
der(Workers) = (Wages) + (-Consume_W); 
der(Banks) = (Interest_F) + (-Buy_B); 

end Connected_Godley_table; 
