library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ParameterPkg.all;

entity testbench is
    Generic (
        input_matrix_width : integer := 4;
        kernel_width : Integer := 2;
        stride : Integer :=1
        );
end testbench;

architecture Behavioral of testbench is
component ConvolutionalLayer
    Generic (
        input_matrix_width : integer;
        kernel_width : Integer;
        stride : Integer
        );
    Port (
        clk_in : IN std_logic;
        reset_in : IN std_logic;
        matrix_in : IN Narray (input_matrix_width * input_matrix_width - 1
            downto 0);
        kernel_in : IN Narray (kernel_width * kernel_width - 1
            downto 0);
        matrix_out : OUT Narray (
            ((input_matrix_width - kernel_width + stride ) / stride) -- output width
            ** 2 -1 downto 0)
        );
end component;

signal clk, reset: STD_LOGIC;
signal matrix_in : Narray (input_matrix_width * input_matrix_width - 1 downto 0);
signal kernel_in : Narray (kernel_width * kernel_width - 1 downto 0);
signal matrix_out : Narray (((input_matrix_width - kernel_width + stride ) / stride) ** 2 -1 downto 0);
begin
    top: ConvolutionalLayer generic map (input_matrix_width =>input_matrix_width, kernel_width =>kernel_width, stride =>stride)
    port map( clk_in=>clk, reset_in=>reset, matrix_in=>matrix_in, kernel_in=>kernel_in, matrix_out=>matrix_out );
    process 
    begin
        matrix_in <= ( x"12", x"22", x"4A", x"16",x"62", x"3F", x"12", x"46",x"52", x"4F", x"1A", x"26",x"22", x"2F", x"2A", x"26");
        kernel_in <= ( x"12", x"1F", x"2A", x"16");
        wait for 10 ns;
    end process;
    process
        begin
        clk <= '1';
        wait for 5ns;
        clk <= '0';
        wait for 5ns;
    end process;
end Behavioral;

