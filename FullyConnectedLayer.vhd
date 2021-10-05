Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ParameterPkg.all;

entity FullyConnectedLayer is
    Generic (
    -- The input and output to the FC layer are vectors.
    input_length : INTEGER := 4;
    output_length : INTEGER := 4
    );
    Port (
    clk_in : IN std_logic;
    reset_in : IN STD_LOGIC;
    
    data_in : IN Narray (input_length - 1 downto 0);
    -- Number of weights = input_length * output_length.
    -- Note that the weight vector should be carefully organized.
    -- [w0, w1, w2, w3], [w4, ...]
    weight_in : IN Narray (input_length * output_length - 1 downto 0);
    bias_in : IN Narray (output_length - 1 downto 0);
    
    result_out : OUT Narray (output_length - 1 downto 0)
    );
end FullyConnectedLayer;

architecture Structural of FullyConnectedLayer is
    component FullyConnectedLayerUnit IS
        Generic (
            vector_length : INTEGER
        );
        Port (
            clk_in : IN std_logic;
            reset_in : IN STD_LOGIC;
            data_in : IN Narray (vector_length - 1 downto 0);
            weight_in : IN Narray (vector_length - 1 downto 0);
            bias_in : IN data_type;
            result_out : OUT data_type
        );
    end component;
begin
    U0 : FOR i IN 0 TO output_length - 1 GENERATE
        DotProductUnit : FullyConnectedLayerUnit
            Generic Map (
                vector_length => input_length
            )
            Port Map (
                clk_in => clk_in,
                reset_in => reset_in,
                data_in => data_in,
                weight_in => weight_in(
                (i + 1) * input_length - 1 downto i * input_length),
                bias_in => bias_in (i),
                result_out => result_out (i)
            );
    END GENERATE;
end Structural;