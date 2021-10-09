Library IEEE;
Use IEEE.STD_LOGIC_1164.all;

-- the output is '1' only when then counter countes to LoopValue
Entity Counter is
    Port (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        
        result_out : OUT STD_LOGIC
    );
End Counter;

Architecture LoopCounter of Counter is
Constant LoopValue : INTEGER := 3; -- counts LoopValue + 1 turns
Begin
    Process (clk_in)
    Variable count_var : Integer Range 0 to 255;
    Begin
        If (clk_in'EVENT AND clk_in = '1') then
            if (reset_in = '1') then
                count_var := 0;
            else
                if (count_var = LoopValue) then
                    count_var := 0;
                    result_out <= '1';
                else
                    count_var := count_var + 1;
                    result_out <= '0';
                end if;
            end if;
        End if;
    End Process;
End LoopCounter;