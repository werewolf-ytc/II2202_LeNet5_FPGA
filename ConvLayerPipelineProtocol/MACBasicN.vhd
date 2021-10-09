Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use work.ParameterPkg.all;
--  Note: in this lab we need to use fixed point numbers.
--        I think the addition and multiplication of fixed point numbers can
--        be implemented with this package.
--        Of course, if there's an existing package for fixed point numbers,
--        it's better to use that one if it's syntesisable.
--        I found a package called ieee_proposed.fixed..., but ieee_proposed
--        doesn't seem so good.

entity MACBasicN is
    Generic(int_length : Integer;   -- length of the integer part
            frac_length : Integer);  -- length of the fractional part
                                 -- the total length N is then the sum of the above two
    Port(a_in, b_in, c_in : IN data_type;
         MAC_out     : OUT data_type
        );
end MACBasicN;

architecture Behavioral of MACBasicN is
Signal MUL_sig : std_logic_vector (2 * (int_length + frac_length) - 1 downto 0);
-- N bits times N bits gives 2N bits
begin
MUL_sig <= a_in * b_in;  -- MUL is composed of 1) integer part, first 2N-1 bits and
               -- 2) fraction, last 2M bits
MAC_out <= MUL_sig(2 * (int_length + frac_length) - 1)  -- sign bit
    & MUL_sig(2 * Frac_length + int_length - 2 downto 2 * frac_length)  -- integer
    & MUL_sig(2 * Frac_length - 1 downto Frac_length) + c_in; -- fractional
--  Note 1: integer part may have overflow problem. Suppose we have originally
--      N bits for the integer part.
--      The range of the theoretical result of multiplication should have 2N-1
--      bits for integer part.
--      Since we only have N bits for output, only the last N bits can be taken.
--      This means if we would output a wrong result for any value having more
--      than N bits.
--      For example, N=2, a=11(unsigned), b=11, result = 1001. This cannot be 
--      the output. Also,  10*10=110, also causing overflow.
--  Note 2: fractional part lose precision. Here the implementation is cut
--      everything at the end (which is efficient).
--      We can of course implement a rounding strategy. But that's more complex
--      to write. It's better to find a existing package for this I think.
end Behavioral;
