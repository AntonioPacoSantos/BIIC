model Firm
  parameter Real period_size = 10;
  parameter Real gamma = 1.1;
  //investment accelerator
  parameter Real phi = 0.1;
  //capital productivity
  parameter Real p = 0.01;
  //price constant
  Real r(start = 0.075);
  //parameter Real r = 0.1;      //cost of capital (interest rate)
  Real Z(start = 2.005);
  //Profits
  Real I(start = 0);
  //Investment
  Real K(start = 1);
  //Capital
  Real B(start = 0);
  //Bank Loans
  Real A(start = 1);
  //Net worth
  Real P(start = 0);
  //Price
  Real U;
  //Stochastic variable
  Real Y(start = 0);
  //Product
  Real R;
  Integer t(start = 0);
  //interest rate
  parameter Integer randomAgentValue(start = 0, fixed = false);
  Integer id;
  Integer globalSeed = 700;
  
  input Real YY; 
  Real l; 
algorithm
  when initial() then
    id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomAgentValue);
    U := Modelica.Math.Random.Utilities.impureRandom(id);
  elsewhen sample(0, period_size) then
    id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomAgentValue);
    U := Modelica.Math.Random.Utilities.impureRandom(id);
  end when;
equation
  when sample(0, period_size) then
    t = pre(t) + 1;

    if t < 500 then
      r = pre(r);
    elseif t < 700 then
      r = 0.1;
    else
      r = 0.15;
    end if;
    R = r + r*(B/A)^r;
    B = max({K - pre(A), 0});
    if pre(A) <= 0 then
      A = 1;
      K = 1;
      Z = 0;
    else
      A = pre(A) + pre(Z);
      K = pre(K) + I;
      Z = P*Y - R*K;
    end if;
    if pre(A) < 0 then
      I = 0;
    else
      I = gamma*pre(Z);
    end if;
    Y = phi*K;
    P = p + U*2;
    l = 13 / YY;
    
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 2),
  Diagram(coordinateSystem(extent = {{0, 0}, {60, -60}})),
  version = "",
  uses);
end Firm;
