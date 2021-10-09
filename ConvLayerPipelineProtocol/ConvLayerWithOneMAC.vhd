Library IEEE;
Use IEEE.STD_LOGIC_1164.all;
Use IEEE.STD_LOGIC_UNSIGNED.all;
Use work.ParameterPkg.all;

-- performs convolution on input feature map with the kernel
-- interface is connected to a memory
Entity ConvLayerWithOneMAC is
    Generic (
        Kernel_width : INTEGER := 2;
        Feature_width : INTEGER := 4
    );
    Port (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        
        data_in : IN data_type;
        weight_in : IN data_type;
        
        result_out : OUT data_type;
        
        weight_c_id_out : OUT STD_LOGIC_VECTOR (Kernel_width downto 0); -- column index
        weight_h_id_out : OUT STD_LOGIC_VECTOR (Kernel_width downto 0); -- horizontal index
        data_c_id_out : OUT STD_LOGIC_VECTOR (Feature_width - Kernel_width + 1 downto 0); -- column index
        data_h_id_out : OUT STD_LOGIC_VECTOR (Feature_width - Kernel_width + 1 downto 0) -- horizontal index
    );
End ConvLayerWithOneMAC;

Architecture Structural of ConvLayerWithOneMAC is
Subtype Feature_Integer is STD_LOGIC_VECTOR (Feature_width - Kernel_width + 1 downto 0);
Subtype Kernel_Integer is STD_LOGIC_VECTOR (Kernel_width downto 0);

Signal One_MAC_loop_sig : STD_LOGIC;
Signal counter1_loop_sig, counter2_loop_sig,
    counter3_loop_sig, counter4_loop_sig : STD_LOGIC;
Signal counter_kernel_c_sig, counter_kernel_h_sig : Kernel_Integer;
Signal counter_data_c_sig, counter_data_h_sig : Feature_Integer;
Begin
    ConvUnit : Entity work.ConvOneMAC(Structural)
        Port Map (
        clk_in => clk_in,
        reset_in => reset_in,
        data_in => data_in,
        weight_in => weight_in,
        plus_select_in => One_MAC_loop_sig,
        result_out => result_out
    );
    One_MAC_loop_sig <= counter1_loop_sig;
    -- One_MAC_loop_sig <= '1' when
--        ((counter_kernel_c_sig = (kernel_width - 1))
--        and (counter_kernel_h_sig = (kernel_width - 1)))
--        else '0';
    Counter_Kernel_1 : Entity work.LoopCounterWithCountOutput (Behavioral)
        Generic Map (
            Loop_value => kernel_width
        )
        Port Map (
        clk_in => clk_in,
        reset_in => reset_in,
        count_out => counter_kernel_c_sig,
        loop_out => counter1_loop_sig
        );
    Counter_Kernel_2 : Entity work.LoopCounterWithCountOutput (Behavioral)
        Generic Map (
            Loop_value => kernel_width
        )
        Port Map (
        clk_in => counter1_loop_sig,
        reset_in => reset_in,
        count_out => counter_kernel_h_sig,
        loop_out => counter2_loop_sig
        );
    Counter_Kernel_3 : Entity work.LoopCounterWithCountOutput (Behavioral)
        Generic Map (
            Loop_value => feature_width - kernel_width + 1
        )
        Port Map (
        clk_in => counter2_loop_sig,
        reset_in => reset_in,
        count_out => counter_data_c_sig,
        loop_out => counter3_loop_sig
    );
    Counter_Kernel_4 : Entity work.LoopCounterWithCountOutput (Behavioral)
        Generic Map (
            Loop_value => feature_width - kernel_width + 1
        )
        Port Map (
        clk_in => counter3_loop_sig,
        reset_in => reset_in,
        count_out => counter_data_h_sig,
        loop_out => counter4_loop_sig
    );
    process (clk_in) begin
    if (clk_in'EVENT and clk_in = '1') then
    weight_c_id_out <= counter_kernel_c_sig;
    end if;
    end process;
    weight_h_id_out <= counter_kernel_h_sig;
    data_c_id_out <= counter_data_c_sig + counter_kernel_c_sig;
    data_h_id_out <= counter_data_h_sig + counter_kernel_h_sig;
End Structural;