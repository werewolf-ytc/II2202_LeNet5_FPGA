Library IEEE;
Use IEEE.STD_LOGIC_1164.all;
Use IEEE.STD_LOGIC_SIGNED.all;
Use work.ParameterPkg.all;

-- Output changes synchronously to the multiplication and accumulation result
-- when plus_select_in is high.
-- Then it accumulates again starting from 0 + input.
Entity ConvOneMAC is
    Port (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        
        data_in : IN data_type;
        weight_in : IN data_type;
        plus_select_in : IN STD_LOGIC;
        
        result_out : OUT data_type
    );
End ConvOneMAC;

Architecture Structural of ConvOneMAC is
Signal mul_out_sig : std_logic_vector (2 * (my_int_length + my_frac_length) - 1 downto 0);
Signal mul_shrink_sig : data_type;
Signal zero_sig : data_type;
Signal plus_in_sig : data_type;
Signal reg_in_sig : data_type;
Signal reg_out_sig : data_type;
Signal output_reg_out_sig : data_type;
Begin
    ZERO : zero_sig <= (others => '0');
    MUL : mul_out_sig <= data_in * weight_in;
    MUL_Shrink : mul_shrink_sig <= mul_out_sig (2 * (my_int_length + my_frac_length) - 1)  -- sign bit
    & mul_out_sig(2 * my_frac_length + my_int_length - 2 downto 2 * my_frac_length)  -- integer
    & mul_out_sig(2 * my_frac_length - 1 downto my_frac_length); -- fractional
    MUX : plus_in_sig <= zero_sig when plus_select_in = '1' else reg_out_sig;
    PLUS : reg_in_sig <= plus_in_sig + mul_shrink_sig;
    REG0 : Process (clk_in, reset_in)
    Begin
        if(clk_in'EVENT and clk_in = '1') then
            if (reset_in = '1') then
                reg_out_sig <= zero_sig;
            else
                reg_out_sig <= reg_in_sig;
            end if;
        end if;
    End process;
    OUTPUT_REG : Process (clk_in, reset_in, plus_in_sig)
    Begin
        if(clk_in'EVENT and clk_in = '1') then
            if (reset_in = '1') then
                output_reg_out_sig <= zero_sig;
            else
                if (plus_select_in = '1') then
                    output_reg_out_sig <= reg_in_sig;
                end if;
            end if;
        end if;
    End process;
    result_out <= output_reg_out_sig;
End Structural;