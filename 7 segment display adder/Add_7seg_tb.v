/* 
Se pot modifica urmatoarele variabile: 
  MORE_INFORMATION:
    1 -> Afiseaza informatii aditionale despre in_1, in_2, expected out.
    0 -> Nu afiseaza aceste informatii

  DISPLAY_PASSED:
    1 -> Afiseaza mesajul de "Test PASSED" pentru fiecare test in parte
    0 -> Nu afiseaza acest mesaj
    
  La fiecare test din fisier, prima linie reprezinta numerele in zecimal, iar mai apoi numerele in afisaj cu 7 seg
*/

module Add_7seg_tb();
  
  reg[7:0] in_1_tb, in_2_tb, out_1_1_exp, out_1_2_exp;
  wire[7:0] out_1_1_actual, out_1_2_actual;
  Add_7seg DUT(.in_1(in_1_tb), .in_2(in_2_tb), 
               .out_1_1(out_1_1_actual), .out_1_2(out_1_2_actual));
               
  integer n_tests, n_tests_passed;
  integer data_file;
  integer ret_fscanf;
  reg[63:0] aString[6:0];
  
  integer MORE_INFORMATION, DISPLAY_PASSED;
  
  integer more_information_in_1, more_information_in_2, more_information_out_1_1, more_information_out_1_2;
  initial begin
    data_file = $fopen("tests_7seg.dat", "r");
    if (data_file == 0) begin
      $display("Adauga fisierul tests_SumSub.dat in acelasi proiect");
      $finish;
    end
    /* ignoram prima linie */
    ret_fscanf = $fscanf(data_file, "%s %s %s %s\n", aString[0], aString[1], aString[2], aString[3]);
    
    /* Parametri configurabili */
    MORE_INFORMATION = 1;
    DISPLAY_PASSED = 1;
    /* ======================= */
    n_tests = 0;
    n_tests_passed = 0;
    
    while(!$feof(data_file)) begin
      n_tests = n_tests + 1;
      ret_fscanf = $fscanf(data_file, "%d %d %d %d\n", more_information_in_1, more_information_in_2, more_information_out_1_1, more_information_out_1_2);
      ret_fscanf = $fscanf(data_file, "%b %b %b %b\n", in_1_tb, in_2_tb, out_1_1_exp, out_1_2_exp);
      #1;
      $display("[Test %3d]", n_tests);
      if(MORE_INFORMATION == 0) begin
        /* do nothing */
      end 
      else begin
        $display("Numerele afisate pe 7 seg");
        $display("in_1 = %d", more_information_in_1);
        $display("in_2 = %d", more_information_in_2);
        $display("out_1_1 = %d", more_information_out_1_1);
        $display("out_1_2 = %d", more_information_out_1_2);
        $display("in_1 = %b", in_1_tb);
        $display("in_2 = %b", in_2_tb);
        $display("Expected out_1_1 = %b", out_1_1_exp);
        $display("Expected out_1_2 = %b", out_1_2_exp);
      end
      if(out_1_1_exp == out_1_1_actual && out_1_2_exp == out_1_2_actual) begin
        if(DISPLAY_PASSED == 1) begin
          $display("Test PASSED");
        end
        n_tests_passed = n_tests_passed + 1;
      end
      else begin
        $display("Test FAILED");
        $display("Actual out_1_1 = %b =/= Expected out_1_1 = %b", out_1_1_actual, out_1_1_exp);
        $display("Actual out_1_2 = %b =/= Expected out_1_2 = %b", out_1_2_actual, out_1_2_exp);
      end
    end
    $display("Teste passed: %d / %d", n_tests_passed, n_tests);
    $fclose(data_file);
  end
endmodule    
