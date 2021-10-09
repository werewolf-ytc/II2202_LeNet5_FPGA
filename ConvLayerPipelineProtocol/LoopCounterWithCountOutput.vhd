Library IEEE;
Use IEEE.STD_LOGIC_1164.all;
Use IEEE.STD_LOGIC_UNSIGNED.all;

-- the output is '1' only when then counter countes to LoopValue
Entity LoopCounterWithCountOutput is
    Generic (
        Loop_value : INTEGER := 4
    );
    Port (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        
        count_out : OUT STD_LOGIC_VECTOR (Loop_Value downto 0);
        loop_out : OUT STD_LOGIC
    );
End LoopCounterWithCountOutput;

Architecture Behavioral of LoopCounterWithCountOutput is
Signal count_sig : STD_LOGIC_VECTOR (Loop_Value downto 0);
Signal loop_sig : STD_LOGIC;
Begin
    Process (clk_in, reset_in)
    Begin
        if (reset_in = '1') then
            count_sig <= (others => '0');
            loop_sig <= '0';
        else
            If (clk_in'EVENT AND clk_in = '1') then
                if (count_sig = Loop_Value - 1) then
                    count_sig <= (others => '0');
                    loop_sig <= '1';
                else
                    count_sig <= count_sig + 1;
                    loop_sig <= '0';
                end if;
            End if;
        end if;
    End Process;
    count_out <= (others => '0') when reset_in = '1' else count_sig;
    loop_out <= '0' when reset_in = '1' else loop_sig;
End Behavioral;