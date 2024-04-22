package GK_Model
  model GK3Debt
    Real v_GK;
    //wage share
    Real e_GK;
    //employment
    Real a_GK(start = 1);
    //productividad del trabajo
    Real N_GK(start = 150);
    //fuerza de trabajo
    Real Pi_GK;
    Real W_GK;
    Real Ig_GK;
    Real I_GK;
    Real K_GK(start = 300);
    Real Y_GK;
    Real L_GK;
    Real w_GK(start = 0.8);
    Real profitRate_GK;
    Real Pg_GK;
    //gross profit
    Real omega_GK;
    //investment function a la Phillips
    Real D_GK(start = 0);
    //deuda
    Real Int_GK;
    //interest payments
    Riccetti_model financial_system;
    parameter Real s_GK = 3, alfa_GK = 0.025, beta_GK = 0.015, deltaK_GK = 0.1, tau_GK = 0.6, rho_GK = 10;
    parameter Real lambda_GK = 10, mu_GK = 0.04, i_GK = 0.04;
    //Traduccion Keen-->notacion nuestra
    //v->s;omega->v;lambda->e;Slambda->rho;Zlambda->tau
    //s: capital-output ratio K/Y
    //alfa: rate of growth of labour productiviy
    //beta: rate of growth of the labour force
    //deltaK: tasa depreciacion del capital
    //rho, tau: definen la tasa de cambio del salario (rho*(e-tau))
  equation
//der(e)= (((1-v)/s - deltaK)-alfa-beta)*e;
//der(v)= (rho*(e-tau)-alfa)*v;
//Productivity
    der(a_GK) = alfa_GK*a_GK;
//Population
    der(N_GK) = beta_GK*N_GK;
//Def de Profit, determinacion del empleo, etc
    I_GK = Ig_GK - deltaK_GK*K_GK;
    der(K_GK) = I_GK;
    Y_GK = K_GK/s_GK;
    L_GK = Y_GK/a_GK;
    e_GK = L_GK/N_GK;
    der(w_GK) = rho_GK*(e_GK - tau_GK)*w_GK;
    W_GK = w_GK*L_GK;
//masa salarial
    v_GK = W_GK/Y_GK;
//wage share
//parte modificada con respecto a la version sin deuda:
    Pg_GK = Y_GK - W_GK;
    Pi_GK = Pg_GK - Int_GK;
    profitRate_GK = Pi_GK/K_GK;
    omega_GK = lambda_GK*(profitRate_GK - mu_GK);
    Ig_GK = Y_GK*omega_GK;
    //der(D_GK) = Ig_GK - Pi_GK;
    D_GK = financial_system.AggregateBFirms;
    Int_GK = i_GK*D_GK;
    annotation(
      experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-06, Interval = 20));
  end GK3Debt;

  model Riccetti_model
    //empieza la sección de ABM
    //parameter setting the seed for the monte carlo iteration
    parameter Integer i(start = 1, fixed = false);
    //number of firms
    inner parameter Integer N = 50;
    //number of banks
    inner parameter Integer Z = 5;
    //a matrix defining each rate of interest (at position ij is the interest rate of the i-th Bank to the j-th Firm)
    inner Real[Z, N] R(start = {{0 for i in 1:N} for i in 1:Z});
    //a matrix defining the chosen bank for each firm (position ij = 1 if j-th Firm chose i-th Bank)
    inner Boolean[Z, N] Phi;
    //a matrix defining the bank who lend to firms that broke
    inner Boolean[N] brokenFirms;
    Firm[N] Firms;
    Bank[Z] Banks;
    //global variables to analyze
    output Real TotalNumberOfBrokenFirms(start = 0);
    output Real AggregateY(start = 0);
    output Real AggregateABanks(start = 0);
    output Real AggregateAFirms(start = 0);
    output Real AggregatePrBanks(start = 0);
    output Real AggregatePrFirms(start = 0);
    output Real AggregateBFirms(start = 0);
    output Real NumberOfBrokenFirms(start = 0);
    output Real NumberOfBrokenBanks(start = 0);
    //simulation cycle: agents sequence order: 1(system_1), 2(bank), 3(system_2), 4(firm), 5(aggregate stats)
    inner parameter Integer delayBank = 2;
    inner parameter Integer delayFirm = 4;
    inner Real[N] firmsLeverage;
    inner Real[N] firmsNetWorth;
    inner Real[N] firmsLoans;
    inner Real[N] firmsRR;
  initial equation
    for firm_index in 1:N loop
      Firms[firm_index].firmId = firm_index;
      Firms[firm_index].randomFirmValue = i*firm_index;
    end for;
    for bank_index in 1:Z loop
      Banks[bank_index].bankId = bank_index;
      Banks[bank_index].randomBankValue = i*bank_index;
    end for;
  equation
    when sample(1, 10) then
//Banks read current Firm status
      firmsLeverage = {Firms[i].leverage for i in 1:N};
      firmsNetWorth = {Firms[i].A for i in 1:N};
      brokenFirms = {Firms[i].isBroken for i in 1:N};
      firmsLoans = {Firms[i].B for i in 1:N};
      firmsRR = {Firms[i].RR for i in 1:N};
      NumberOfBrokenFirms = sum_all_true_valued_elements(brokenFirms, {1 for i in 1:N});
      TotalNumberOfBrokenFirms = pre(TotalNumberOfBrokenFirms) + NumberOfBrokenFirms;
    end when;
    when sample(3, 10) then
      for bank_index in 1:Z loop
        for firm_index in 1:N loop
//Banks update R matrix
          R[bank_index, firm_index] = Banks[bank_index].R_B[firm_index];
        end for;
      end for;
//Each firm updates all his possible choices for a new interest rate value
//Firms update Phi matrix
      for firm_index in 1:N loop
        for bank_index in 1:Z loop
          if Firms[firm_index].chosenBank == bank_index then
            Phi[bank_index, firm_index] = true;
          else
            Phi[bank_index, firm_index] = false;
          end if;
        end for;
      end for;
      NumberOfBrokenBanks = sum_all_true_valued_elements({Banks[i].isBroken for i in 1:Z}, {1 for i in 1:Z});
    end when;
  algorithm
    when sample(9, 10) then
      AggregateY := 0;
      for firm_index in 1:N loop
        AggregateY := AggregateY + Firms[firm_index].Y;
      end for;
      AggregateABanks := sum({Banks[i].A for i in 1:Z});
      AggregateAFirms := sum(firmsNetWorth);
      AggregatePrBanks := sum({Banks[i].Pr for i in 1:Z});
      AggregatePrFirms := sum({Firms[i].Pr for i in 1:Z});
      AggregateBFirms := sum({Firms[i].B for i in 1:Z});
    end when;
    annotation(
      experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-06, Interval = 20),
      __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
  end Riccetti_model;

  model Firm
    parameter Real phi = 3;
    parameter Real beta = 0.7;
    parameter Integer firmId(fixed = false);
    parameter Real adj = 0.05;
    //Biggest acceptable change for leverage value
    parameter Real alpha = 0.1;
    //p mean
    parameter Real var_p = 0.4;
    //p variance
    parameter Real lambda = 4;
    output Real Y(start = 0);
    //Product
    output Real K(start = 0);
    //Capital
    output Real B(start = 0);
    //Debt
    output Real A(start = 10);
    //Net value
    output Real Pr(start = 0);
    //Profit
    output Real leverage(start = 1);
    output Integer chosenBank(start = 1);
    Boolean isBroken(start = false);
    Real p(start = 0.4);
    //Revenue
    Real u(start = 0.5);
    Real currentR(start = 1);
    Real RR(start = 0);
    outer Real[:, :] R;
    outer Integer delayFirm;
    outer Integer Z;
    //random number generations
    parameter Integer randomFirmValue(start = 0, fixed = false);
    Integer id;
    Integer globalSeed = 700;
    Real U(start = 1);
    Integer L(start = 3);
    parameter Integer randomFirmValue2(start = 3, fixed = false);
    Integer id2;
    Integer globalSeed2 = 900;
    Integer L2(start = 10);
    Real probability_of_change(start = 0);
  algorithm
//creacion de numeros aleatorios para variables aleatorias
    when initial() then
      id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomFirmValue);
      U := Modelica.Math.Random.Utilities.impureRandom(id);
      id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomFirmValue);
      L := Modelica.Math.Random.Utilities.impureRandomInteger(id, 1, Z);
      id2 := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed2*randomFirmValue2);
      L2 := Modelica.Math.Random.Utilities.impureRandomInteger(id2, 1, Z);
    elsewhen sample(1, 10) then
      id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomFirmValue);
      U := Modelica.Math.Random.Utilities.impureRandom(id);
      id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomFirmValue);
      L := Modelica.Math.Random.Utilities.impureRandomInteger(id, 1, Z);
      id2 := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed2*randomFirmValue2);
      L2 := Modelica.Math.Random.Utilities.impureRandomInteger(id2, 1, Z);
    end when;
  equation
    when sample(delayFirm, 10) then
      currentR = R[chosenBank, firmId];
      probability_of_change = 1 - Modelica.Math.exp(lambda*(R[select_min_value_index_from_rows(min({L, L2}), max({L, L2}), R[:, firmId]), firmId] - pre(currentR))/R[select_min_value_index_from_rows(min({L, L2}), max({L, L2}), R[:, firmId]), firmId]);
      if pre(A) + pre(Pr) < 0 then
        chosenBank = L;
        A = U*2;
        Pr = 0;
        leverage = 1;
        isBroken = true;
        RR = max({0, -(pre(A) + pre(Pr))});
        Y = 0;
      else
        if R[select_min_value_index_from_rows(min({L, L2}), max({L, L2}), R[:, firmId]), firmId] < pre(currentR) then
          if U < probability_of_change then
            chosenBank = select_min_value_index_from_rows(min({L, L2}), max({L, L2}), R[:, firmId]);
          else
            chosenBank = pre(chosenBank);
          end if;
        else
          chosenBank = pre(chosenBank);
        end if;
        A = pre(A) + pre(Pr);
        if p > R[chosenBank, firmId] then
          leverage = pre(leverage)*(1 + (adj*u));
        else
          leverage = pre(leverage)*(1 - (adj*u));
        end if;
        isBroken = false;
        RR = 0;
        Pr = p*Y - R[chosenBank, firmId]*B;
        Y = phi*K^beta;
      end if;
      u = U;
      p = alpha + sqrt(var_p)*(sqrt(12))*(U - 0.5);
      K = B + A;
      B = A*leverage;
    end when;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
      __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
      __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", variableFilter = ".*"));
  end Firm;

  model Bank
    //Provided interest rates
    outer parameter Integer N;
    output Real[N] R_B;
    parameter Real policy_rate = 0.002;
    parameter Real gamma = 0.02;
    parameter Integer bankId(fixed = false);
    Real interests;
    output Real bad;
    //parte
    output Real D;
    //Depositos
    output Real A(start = 10);
    //net worth
    output Real Pr(start = 0);
    parameter Real c = 0.01;
    //fixed bank cost
    outer Integer delayBank;
    output Boolean isBroken;
    //Information about each of the firms
    outer Real[:] firmsLeverage;
    outer Real[:] firmsNetWorth;
    outer Real[:] firmsLoans;
    outer Real[:] firmsRR;
    outer Boolean[:, :] Phi;
    outer Boolean[:] brokenFirms;
    //random number generations
    parameter Integer randomBankValue(start = 0, fixed = false);
    Integer id;
    Integer globalSeed = 700;
    Real U(start = 1);
  algorithm
//creacion de numeros aleatorios para variables aleatorias
    when initial() then
      id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomBankValue);
      U := Modelica.Math.Random.Utilities.impureRandom(id);
    elsewhen sample(delayBank, 10) then
      id := Modelica.Math.Random.Utilities.initializeImpureRandom(integer(time) + globalSeed*randomBankValue);
      U := Modelica.Math.Random.Utilities.impureRandom(id);
    end when;
  equation
//The firm updates each of the interest rates
    when sample(delayBank, 10) then
      if pre(A) + pre(Pr) < 0 then
        A = U*2;
        isBroken = true;
      else
        A = pre(A) + pre(Pr);
        isBroken = false;
      end if;
      for i in 1:size(R_B, 1) loop
        R_B[i] = policy_rate + gamma*A^(-gamma) + gamma*(firmsLeverage[i]/(1 + (firmsNetWorth[i]/max(firmsNetWorth))));
      end for;
      D = sum_all_true_valued_elements(Phi[bankId], firmsLoans) - A;
      bad = sum_all_true_valued_elements(brokenFirms and Phi[bankId], firmsRR);
      interests = sum_all_true_valued_elements(Phi[bankId], hadamard_product(R_B, firmsLoans));
      Pr = interests - policy_rate*D - c*A - bad;
    end when;
  end Bank;

  function select_min_value_index
    input Real R_F[:];
    output Integer chosenBank;
  algorithm
    chosenBank := 1;
    for i in 1:size(R_F, 1) loop
      if R_F[i] < R_F[chosenBank] then
        chosenBank := i;
      end if;
    end for;
  end select_min_value_index;

  function sum_all_true_valued_elements
    input Boolean[:] Phi;
    input Real[:] firmsLoans;
    output Real d;
  protected
    Real[:] binaryArray;
  algorithm
    binaryArray := {if Phi[i] == false then 0 else 1 for i in 1:size(Phi, 1)};
    d := sum({binaryArray[i]*firmsLoans[i] for i in 1:size(firmsLoans, 1)});
  end sum_all_true_valued_elements;

  function hadamard_product
    input Real[:] v1;
    input Real[:] v2;
    output Real[:] result;
  algorithm
    result := {v1[i]*v2[i] for i in 1:size(v1, 1)};
  end hadamard_product;

  function select_min_value_index_from_rows
    input Integer fst;
    input Integer lst;
    input Real R_F[:];
    output Integer chosenBank;
  algorithm
    chosenBank := select_min_value_index({R_F[i] for i in fst:lst});
  end select_min_value_index_from_rows;
end GK_Model;
