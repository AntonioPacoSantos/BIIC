model BertrandEdgeworthModel
  parameter Real M = 3;
  //demanda agregada
  parameter Integer N = 5;
  //cantidad de firmas
  parameter Real c = 1;
  //costo marginal unitario
  parameter Real y = 10;
  //oferta
  output Real[N] P;
  //precios
  Firms[N] F;
  //firmas
  output Real[N] Z(start = {0 for i in 1:N});
  //cantidades vendidas
initial equation
  for i in 1:N loop
    F[i].c = c;
    F[i].y = y;
    F[i].firmNumber = i;
    P[i] = i;
    F[i].z = Z[i];
  end for;
equation
  when sample(1, 10) then
    Z = buyingProcess(P,N,M,y);
    for i in 1:N loop
      F[i].z = Z[i];
    end for;
  end when;
  when sample(3, 10) then
    for i in 1:N loop
      P[i] = F[i].p;
    end for;
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
end BertrandEdgeworthModel;
