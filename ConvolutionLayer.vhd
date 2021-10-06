library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use work.ParameterPkg.all;

entity ConvolutionLayer is
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
end ConvolutionLayer;

architecture ConvolutionBehavioral of ConvolutionLayer is

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

type KernelArray is array (natural range <>) of Narray(kernel_width * kernel_width - 1
            downto 0);

CONSTANT output_matrix_width : INTEGER
    := (input_matrix_width - kernel_width + stride ) / stride;
    
-- Convolutional layer performs convolution of kernel on input matrix
    signal Matrix_Segment : KernelArray(output_matrix_width * output_matrix_width - 1
            downto 0);
BEGIN   
    process(Matrix_Segment, matrix_in, clk_in, reset_in)
    begin
    for i in 0 to output_matrix_width - 1 loop
        for j in 0 to output_matrix_width - 1 loop
            for m in 0 to kernel_width  - 1 loop
                for n in 0 to kernel_width - 1 loop
                    Matrix_Segment(Matrix2VectorIndexConvertion(output_matrix_width, i, j))
                    (Matrix2VectorIndexConvertion(kernel_width, m, n)) <= 
                    matrix_in(Matrix2VectorIndexConvertion(input_matrix_width, i * stride + m, j * stride + n));
            --Matrix_Segment(i)(k*kernel_width-1 to 
            --k*kernel_width +kernel_width -1)<=matrix_in(i*stride +j*stride*input_matrix_width + 
            --k * input_matrix_width to i*stride +j*stride*input_matrix_width +  k * input_matrix_width + kernel_width - 1) ;
                end loop;
            end loop;
        end loop;
    end loop;
end process;
    GEN1: for l in 0 to output_matrix_width * output_matrix_width - 1 generate
        U0: ConvMACUnit Generic map (vector_length => kernel_width * kernel_width)
        port map(clk_in => clk_in, reset_in => reset_in, 
        data_in => Matrix_Segment(l),
        kernel_in => kernel_in,
        result_out => matrix_out(l));
    end generate;

end ConvolutionBehavioral;