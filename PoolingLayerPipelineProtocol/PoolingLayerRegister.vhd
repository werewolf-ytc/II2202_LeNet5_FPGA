Library IEEE;
Use IEEE.STD_LOGIC_1164.all;
Use work.ParameterPkg.all;

Entity PoolingLayerRegister is
    Port (
        clk_in : IN STD_LOGIC;
        enable_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC; -- synchronous
        data_in : IN data_type;
        data_out : OUT data_type
    );
End PoolingLayerRegister;

Architecture WithEnable of PoolingLayerRegister is
Signal reg_sig : data_type;
Begin
    Process (clk_in, enable_in, reset_in, data_in)
    Begin
        if (clk_in'EVENT and clk_in = '1') then
            if (reset_in = '1') then
                reg_sig <= (others => '0');
            else
                if (enable_in = '1') then
                    reg_sig <= data_in;
                end if;
            end if;
        end if;
    End process;
    data_out <= reg_sig;
End WithEnable;

Architecture NoEnable of PoolingLayerRegister is
Signal reg_sig : data_type;
Begin
    Process (clk_in, reset_in, data_in)
    Begin
        if (clk_in'EVENT and clk_in = '1') then
            if (reset_in = '1') then
                reg_sig <= (others => '0');
            else
                reg_sig <= data_in;
            end if;
        end if;
    End process;
    data_out <= reg_sig;
End NoEnable;