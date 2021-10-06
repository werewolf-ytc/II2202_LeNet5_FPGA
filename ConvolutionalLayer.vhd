library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use work.ParameterPkg.all;


entity ConvolutionalLayer is
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
end ConvolutionalLayer;

architecture ConvolutionBehavioral of ConvolutionalLayer is
CONSTANT output_matrix_width : INTEGER
    := (input_matrix_width - kernel_width + stride ) / stride;
    
-- Convolutional layer performs convolution of kernel on input matrix
FUNCTION ConvolutionFunction (
    matrix_in : IN Narray (input_matrix_width * input_matrix_width - 1
            downto 0);
    kernel_in : IN Narray (kernel_width * kernel_width - 1
            downto 0)
    ) RETURN Narray IS
    VARIABLE matrix_return : Narray (
            ((input_matrix_width - kernel_width + stride ) / stride)  -- output width
            ** 2 -1 downto 0);
    VARIABLE local_feature : data_type;        
BEGIN
    for i in output_matrix_width - 1 downto 0 loop
        for j in output_matrix_width - 1 downto 0 loop
            local_feature  := x"00";
            for p in kernel_width - 1 downto 0 loop
                for q in kernel_width - 1 downto 0 loop                
                    local_feature := matrix_in(Matrix2VectorIndexConvertion(
                        input_matrix_width, stride * i + p, stride * j + q))(7 downto 4)* kernel_in(Matrix2VectorIndexConvertion(
                        kernel_width, p, q))(7 downto 4) + local_feature;
                end loop;
            end loop;
        matrix_return(Matrix2VectorIndexConvertion(
            output_matrix_width, i, j)) := local_feature;
        end loop;
    end loop;
    RETURN matrix_return;
END;

BEGIN

matrix_out <= ConvolutionFunction(matrix_in, kernel_in);

end ConvolutionBehavioral;
