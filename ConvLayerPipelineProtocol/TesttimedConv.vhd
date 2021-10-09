library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ParameterPkg.all;

entity TesttimedConv is
--  Port ( );
end TesttimedConv;

architecture Behavioral of TesttimedConv is
Constant Input_matrix_width: INTEGER := 4;
Constant kernel_width: INTEGER := 2;
Constant Stride: INTEGER := 1;
component ConvLayerTimed is
    Generic (
        input_matrix_width : integer:=4;
        kernel_width : Integer:=2;
        stride : Integer:=1
        );
    Port (
        clk_in : IN std_logic;
        reset_in : IN std_logic;
        matrix_in : IN Narray (input_matrix_width * input_matrix_width - 1
            downto 0);
        kernel_in : IN Narray (kernel_width * kernel_width - 1
            downto 0);
        matrix_out : OUT Narray (
            ((input_matrix_width - kernel_width + stride ) / stride)  -- output width
            ** 2 -1 downto 0)
        );
end component;

signal clk, reset: STD_LOGIC:='1';
signal matrix_in : Narray (input_matrix_width * input_matrix_width - 1 downto 0);
signal kernel_in : Narray (kernel_width * kernel_width - 1 downto 0);
signal matrix_out : Narray (((input_matrix_width - kernel_width + stride ) / stride) ** 2 -1 downto 0);
begin
    top: ConvLayerTimed generic map (input_matrix_width =>input_matrix_width, kernel_width =>kernel_width, stride =>stride)
    port map( clk_in=>clk, reset_in=>reset, matrix_in=>matrix_in, kernel_in=>kernel_in, matrix_out=>matrix_out );
    process 
    begin
        matrix_in <= ( x"10", x"30", x"40", x"50", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"0A", x"20", x"50", x"10");
        kernel_in <= ( x"e0", x"10", x"10", x"10");
        wait for 10 ns;
    end process;
    process
        begin
        clk <= '1';
        wait for 5ns;
        clk <= '0';
        wait for 5ns;
    end process;
        process
    begin
        reset <='0';
        reset <='1';
        wait for 10ns;
        reset <='0';
        wait for 200ns;
    end process;

end Behavioral;

