`timescale 1ns / 1ps
`define HEADER_SIZE 1080
`define IMAGE_SIZE 512*512

module tb_ImageProcessTop();

  reg axi_clk;
  reg axi_rst_n;
  reg [7:0] pixel_in;
  reg pixel_vin;
  integer file, file1, i, tmp;
  integer sentSize;
  wire intr;
  wire [7:0] pixel_out;
  wire pixel_vout;
  reg master_ready;
  integer receivedData = 0;

  // Clock generation
  initial begin
    axi_clk = 1'b0;
    forever #5 axi_clk = ~axi_clk;
  end

  // Testbench logic
  initial begin
    axi_rst_n = 1'b0;
    sentSize = 0;
    pixel_vin = 1'b0;
    master_ready = 1'b1;
    #100;
    axi_rst_n = 1'b1;
    #100;

    // Open input and output image files
    file = $fopen("lena_gray.bmp", "rb");
    file1 = $fopen("blurred_lena.bmp", "wb");

    // Copy header from input to output file
    for (i = 0; i < `HEADER_SIZE; i = i + 1) begin
      tmp = $fscanf(file, "%c", pixel_in);
      $fwrite(file1, "%c", pixel_in);
    end

    // Process the image in chunks
    for (i = 0; i < 4 * 512; i = i + 1) begin
      @(posedge axi_clk);
      tmp = $fscanf(file, "%c", pixel_in);
      pixel_vin <= 1'b1;
    end
    sentSize = 4 * 512;
    @(posedge axi_clk);
    pixel_vin <= 1'b0;

    while (sentSize < `IMAGE_SIZE) begin
      @(posedge intr);
      for (i = 0; i < 512; i = i + 1) begin
        @(posedge axi_clk);
        tmp = $fscanf(file, "%c", pixel_in);
        pixel_vin <= 1'b1;
      end
      @(posedge axi_clk);
      pixel_vin <= 1'b0;
      sentSize = sentSize + 512;
    end

    // Padding for final processing
    @(posedge axi_clk);
    pixel_vin <= 1'b0;
    @(posedge intr);
    for (i = 0; i < 512; i = i + 1) begin
      @(posedge axi_clk);
      pixel_in <= 8'b0;
      pixel_vin <= 1'b1;
    end
    @(posedge axi_clk);
    pixel_vin <= 1'b0;
    @(posedge intr);
    for (i = 0; i < 512; i = i + 1) begin
      @(posedge axi_clk);
      pixel_in <= 8'b0;
      pixel_vin <= 1'b1;
    end
    @(posedge axi_clk);
    pixel_vin <= 1'b0;

    $fclose(file);
  end

  // Write output data to file
  always @(posedge axi_clk) begin
    if (pixel_vout) begin
      $fwrite(file1, "%c", pixel_out);
      receivedData = receivedData + 1;
    end
    if (receivedData == `IMAGE_SIZE) begin
      $fclose(file1);
      $stop;
    end
  end

  // DUT instantiation
  ImageProcessTop dut (
    .axi_clk(axi_clk),
    .axi_rst_n(axi_rst_n),
    // Slave Interface
    .pixel_in(pixel_in),
    .pixel_vin(pixel_vin),
    .slave_ready(),
    // Master Interface
    .pixel_out(pixel_out),
    .pixel_vout(pixel_vout),
    .master_ready(master_ready),
    
   // .s_axis_tuser(),
   // .m_axis_tuser(),
    // Interrupt
    .intr(intr)
  );

endmodule
