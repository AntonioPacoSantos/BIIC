
model lotka_volterra

  Real x(start = 10); 
  Real y(start = 10); 
  parameter Real alpha = 0.5; 
  parameter Real beta = 0.3; 
  parameter Real delta = 0.8; 
  parameter Real gamma = 0.2;
  parameter Real stopTime = 1; 
   
equation
  der(x) = alpha*x-beta*x*y; 
  der(y) = delta*x*y-gamma*y;
   
  algorithm
when terminal() then 
    Modelica.Utilities.System.command("python3 /home/antonio/BIIC/plot_modelica.py");
  end when;





annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end lotka_volterra;