library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ParameterPkg.all;

entity PoolingLayer is
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
end PoolingLayer;

architecture MaxPoolBehavioral of PoolingLayer is
CONSTANT output_matrix_width : INTEGER
    := (input_matrix_width - filter_width + stride ) / stride;

-- Max pool the input matrix
FUNCTION MaxPoolingFunction (
    matrix_in : IN Narray (input_matrix_width * input_matrix_width - 1
            downto 0)
    ) RETURN Narray IS
    VARIABLE matrix_return : Narray (
    ((input_matrix_width - filter_width + stride ) / stride)  -- output width
    ** 2 - 1 downto 0);
    VARIABLE local_max_var : data_type;        
BEGIN
    for i in output_matrix_width - 1 downto 0 loop
        for j in output_matrix_width - 1 downto 0 loop
        -- for each pooled value
        
            local_max_var := matrix_in (Matrix2VectorIndexConvertion(
                input_matrix_width, i, j));
            for p in filter_width - 1 downto 0 loop
                for q in filter_width - 1 downto 0 loop
                    -- find the max within a window
                    
                    if (matrix_in(Matrix2VectorIndexConvertion(
                        input_matrix_width, stride * i + p, stride * j + q))
                        > local_max_var) then
                        local_max_var := matrix_in(
                            Matrix2VectorIndexConvertion(
                            input_matrix_width, stride * i + p, stride * j + q
                            )
                            );
                    end if;
                end loop;
            end loop;
        matrix_return(Matrix2VectorIndexConvertion(
            output_matrix_width, i, j)) := local_max_var;
        end loop;
    end loop;
    RETURN matrix_return;
END;

BEGIN

matrix_out <= MaxPoolingFunction(matrix_in);

end MaxPoolBehavioral;
