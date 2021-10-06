library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use work.ParameterPkg.all;

entity Testbenchkernel is
    Generic (
        input_matrix_width : integer := 4;
        kernel_width : Integer := 2;
        stride : Integer :=1
        );
end Testbenchkernel;

architecture testkernel of Testbenchkernel is

component KernelMACUnit is
 Generic (
        kernel_width : Integer
        );
    Port (
        matrix_segment_in : IN Narray (kernel_width * kernel_width - 1
            downto 0);
        kernel_in : IN Narray (kernel_width * kernel_width - 1
            downto 0);
        clk: IN STD_LOGIC;
        reset: IN STD_LOGIC;
        matrix_out : OUT Integer 
        );
end component;

signal clk, reset: STD_LOGIC;
signal matrix_in : Narray (kernel_width * kernel_width - 1
            downto 0);
signal kernel_in : Narray (kernel_width * kernel_width - 1 downto 0);
signal matrix_out :integer;
begin
    Unit1: KernelMACUnit Generic map (kernel_width=>kernel_width)
        port map(matrix_segment_in=>matrix_in,
        kernel_in=>kernel_in,
        reset => reset,
        clk=>clk,
        matrix_out=>matrix_out);
    process 
    begin
        matrix_in <= (1,2,1,1);
        kernel_in <= (1,2,1,1);
        wait for 10 ns;
        matrix_in <=(1,2,1,1);
        kernel_in <= (1,2,1,1);
        --matrix_in <= ( x"12", x"22", x"4A", x"16",x"62", x"3F", x"12", x"46",x"52", x"4F", x"1A", x"26",x"22", x"2F", x"2A", x"26");
        --kernel_in <= ( x"12", x"1F", x"2A", x"16");
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
        reset <='1';
        wait for 10ns;
        reset <='0';
        wait for 200ns;
    end process;



end testkernel;