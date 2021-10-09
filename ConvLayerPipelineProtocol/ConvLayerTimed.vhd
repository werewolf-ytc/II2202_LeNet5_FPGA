library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use work.ParameterPkg.all;

entity ConvLayerTimed is
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
end ConvLayerTimed;

architecture TimedBehavioral of ConvLayerTimed is

component ConvMACUnit is
  Generic (
    vector_length : integer := 4
    );
  Port(
    clk_in : IN std_logic;
    reset_in : IN std_logic;
    data_in : IN Narray (vector_length - 1 downto 0);
    kernel_in : IN Narray (vector_length - 1 downto 0);
    result_out : OUT data_type
  );
end component;

CONSTANT output_matrix_width : INTEGER
    := (input_matrix_width - kernel_width + stride ) / stride;
constant kernel_width_con: integer := kernel_width ;
    
-- Convolutional layer performs convolution of kernel on input matrix
    signal i, j: integer;
    signal Matrix_Segment: Narray(kernel_width * kernel_width - 1
            downto 0);
    signal Output:data_type ;
    signal matrix_out_reg: Narray (
            ((input_matrix_width - kernel_width + stride ) / stride)  -- output width
            ** 2 -1 downto 0);
BEGIN   
    process(clk_in, reset_in,i,j,Matrix_Segment)
    begin
    if (reset_in = '1') then
        i <= 0;
        j <= 0;
    elsif (clk_in 'event and clk_in ='0') then
        if (i = output_matrix_width-1 and j = output_matrix_width -1) then
            i <= 0;
            j <= 0;
            matrix_out <= matrix_out_reg;
        elsif (i = output_matrix_width-1 and j /= output_matrix_width -1) then
            i <= 0;
            j <= j + 1;
        else
            i <= i + 1;
        end if;
    end if;
    if (i >= 0) and (j >= 0) then
            for m in 0 to kernel_width  - 1 loop
            for n in 0 to kernel_width - 1 loop
                Matrix_Segment(Matrix2VectorIndexConvertion(kernel_width, m, n)) <= 
                matrix_in(Matrix2VectorIndexConvertion(input_matrix_width, j * stride + m, i * stride + n));
            end loop;
         end loop;
         matrix_out_reg(j*output_matrix_width+i) <= Output;
     end if;
end process;

    Unit1:ConvMACUnit Generic map (vector_length => kernel_width * kernel_width)
        port map(clk_in => clk_in, reset_in => reset_in, 
        data_in => Matrix_Segment,
        kernel_in => kernel_in,
        result_out => Output);

end TimedBehavioral;