Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ParameterPkg.ALL;

Entity TestBenchFullyConnectedLayer IS

End TestBenchFullyConnectedLayer;

Architecture Test of TestBenchFullyConnectedLayer IS
    Constant Input_length_test : INTEGER := 2;
    Constant Output_length_test : INTEGER := 2;
    
    Signal Clk_test : STD_LOGIC := '0';
    Signal Reset_test : STD_LOGIC := '0';
    Signal Data_test : Narray (Input_length_test - 1 downto 0)
    := (others => (others => '0'));
    Signal Weight_test : Narray (
    input_length_test * output_length_test - 1 downto 0)
    := (others => (others => '0'));
    Signal Bias_test : Narray (output_length_test - 1 downto 0)
    := (others => (others => '0'));
    Signal Result_test : Narray (output_length_test - 1 downto 0)
    := (others => (others => '0'));
    
    Component FullyConnectedLayer IS
        Generic (
        input_length : INTEGER;
        output_length : INTEGER
        );
        Port (
        clk_in : IN std_logic;
        reset_in : IN STD_LOGIC;
        data_in : IN Narray (input_length - 1 downto 0);
        weight_in : IN Narray (input_length * output_length - 1 downto 0);
        bias_in : IN Narray (output_length - 1 downto 0);
        result_out : OUT Narray (output_length - 1 downto 0)
        );
    end Component;
Begin
    UUT : FullyConnectedLayer
        Generic Map (
        input_length => Input_length_test,
        output_length => Output_length_test
        )
        Port Map (
        clk_in => clk_test,
        reset_in => reset_test,
        data_in => data_test,
        weight_in => weight_test,
        bias_in => bias_test,
        result_out => result_test
        );
        
    Data_process : Process Begin
        Data_test <= (x"20", x"20");
        Weight_test <= (x"20", x"20", x"20", x"20");
        Bias_test <= (x"20", x"20");
        wait for 10 ns;
    End Process;
        
    CLK_process : Process Begin
        CLK_test <= '0';
        wait for 10 ns;
        CLK_test <= '1';
        wait for 10 ns;
    End process;
End Test;