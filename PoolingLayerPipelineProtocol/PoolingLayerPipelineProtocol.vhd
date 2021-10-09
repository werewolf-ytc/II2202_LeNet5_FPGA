Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use Work.ParameterPkg.all;

Entity PoolingLayerPipelineProtocol is
    Generic (
        input_matrix_width : INTEGER := 4
    );
    Port (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        
        data_in : IN data_type;
        
        data_out : OUT data_type
    );
End PoolingLayerPipelineProtocol;

Architecture Structural of PoolingLayerPipelineProtocol is
Signal Activate_sig : STD_LOGIC;
Signal Comparator_output_sig : data_type;
Signal Mux_output_sig : data_type;
Signal Reg_output_sig : data_type;

Begin
    Comparator0 : Entity Work.Comparator(Dataflow)
        Port Map (
            input_data_1 => Reg_output_sig,
            input_data_2 => data_in,
            result_out => Comparator_output_sig
        );
    Mux0 : Mux_output_sig <= data_in when Activate_sig = '1' else Reg_output_sig;
    Counter0 : Entity Work.Counter(LoopCounter)
        Port Map (
            clk_in => clk_in,
            reset_in => reset_in,
            result_out => Activate_sig
        );
    ShiftReg : Entity Work.PoolingLayerRegister (NoEnable)
        Port Map (
            clk_in => clk_in,
            enable_in => '0',
            reset_in => reset_in,
            data_in => data_in,
            data_out => Reg_output_sig
        );
    OutputReg : Entity Work.PoolingLayerRegister (WithEnable)
        Port Map (
            clk_in => clk_in,
            enable_in => Activate_sig,
            reset_in => reset_in,
            data_in => Reg_output_sig,
            data_out => data_out
        );
End Structural;