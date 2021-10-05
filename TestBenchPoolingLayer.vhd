Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ParameterPkg.ALL;

Entity TestBenchPoolingLayer IS

End TestBenchPoolingLayer;

Architecture Test of TestBenchPoolingLayer IS
    Constant Input_matrix_width_test : INTEGER := 4;
    Constant filter_width_test : INTEGER := 2;
    Constant Stride_test : INTEGER := 2;
    
    Signal Clk_test : STD_LOGIC := '0';
    Signal Reset_test : STD_LOGIC := '0';
    Signal Matrix_test : Narray (input_matrix_width_test ** 2 - 1
        downto 0);
    Signal Result_matrix_test : Narray (
    ((input_matrix_width_test - filter_width_test + stride_test ) / stride_test)  -- output width
    ** 2 -1 downto 0);
      
    Component PoolingLayer is
        Generic (
        input_matrix_width : integer;
        filter_width : Integer;
        stride : Integer
        );
        Port (
        clk_in : IN std_logic;
        reset_in : IN std_logic;
        matrix_in : IN Narray (input_matrix_width * input_matrix_width - 1
        downto 0);
        matrix_out : OUT Narray (
        ((input_matrix_width - filter_width + stride ) / stride)  -- output width
        ** 2 -1 downto 0)
        );
    end Component;
Begin
    UUT : PoolingLayer
        Generic Map (
        input_matrix_width => Input_matrix_width_test,
        filter_width => filter_width_test,
        stride => stride_test
        )
        Port  Map(
        clk_in => Clk_test,
        reset_in => reset_test,
        matrix_in => matrix_test,
        matrix_out => result_matrix_test
        );
        
    Data_process : Process Begin

        matrix_test <= (x"20", x"10", x"11", x"30",
        x"20", x"20", x"20", x"20",
        x"20", x"20", x"20", x"20",
        x"20", x"20", x"20", x"20");
        wait for 10 ns;
    End Process;
        
    CLK_process : Process Begin
        CLK_test <= '0';
        wait for 10 ns;
        CLK_test <= '1';
        wait for 10 ns;
    End process;
End Test;