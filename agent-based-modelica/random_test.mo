model random_test
  
  output Integer L(start = 2); 
  parameter Boolean[3] b = {true,true,false};
  equation 

    L = sum(b);
  
end random_test;
