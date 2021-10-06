library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use work.ParameterPkg.all;


entity KernelMACUnit is
 Generic (
        kernel_width : Integer:=2
        );
    Port (
        matrix_segment_in : IN Narray (kernel_width * kernel_width - 1
            downto 0) ; 
        kernel_in : IN Narray (kernel_width * kernel_width - 1
            downto 0);
        reset: IN STD_LOGIC;
        clk: IN STD_LOGIC;
        matrix_out : OUT Integer 
        );
end KernelMACUnit;
architecture KernelMACUnitBehavioral of KernelMACUnit is
    
-- Convolutional layer performs convolution of kernel on input matrix
constant kernel_width_con :integer  := kernel_width;
BEGIN   
    process(matrix_segment_in, kernel_in , reset)
    variable local_feature :integer;
    variable i:integer;
    begin
    if (reset = '1') then
        matrix_out<=0;
    else
        local_feature := matrix_segment_in(0)* kernel_in(0);
        for i in 1 to kernel_width_con * kernel_width_con  - 1 loop
            local_feature := matrix_segment_in(i)* kernel_in(i)+ local_feature;
        end loop;
    end if;
    matrix_out<= local_feature;
end process;


end KernelMACUnitBehavioral;
