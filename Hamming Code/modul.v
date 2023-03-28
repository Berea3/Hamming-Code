module ECC(input[31:0] data_in, output reg[31:0] data_out, output reg err_2_bit);
  reg[5:0] val;
  reg c,d;
  integer i;
  always@(*) begin
    val=5'b000000;
    c=0;
    val=0;
    for (i=0;i<=31;i=i+1) begin
      if (data_in[i]==1) begin
        val=val^i;
      end
      c=c^data_in[i];
    end
    if (val==0 && c==0) begin
      data_out=data_in;
      err_2_bit=0;
    end
    if (val==0 && c==1) begin
      data_out=data_in;
      data_out[0]=~data_in[0];
      err_2_bit=0;
    end
    if (val!=0 && c==1) begin
      data_out=data_in;
      data_out[val]=~data_in[val];
      err_2_bit=0;
    end
    if (val!=0 && c==0) begin
      data_out=data_in;
      err_2_bit=1;
    end
  end
endmodule