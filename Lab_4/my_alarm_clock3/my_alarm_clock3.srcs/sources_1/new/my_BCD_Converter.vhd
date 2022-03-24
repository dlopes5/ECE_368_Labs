LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY my_BCD_Converter IS
    PORT ( 
           Ain: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
           SegPatternOut: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
           );
END my_BCD_Converter;

ARCHITECTURE Structural of my_BCD_Converter IS

SIGNAL SegOut: STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN 
SegPatternOut <= NOT "1111110" WHEN Ain ="0000" ELSE --0
          NOT "0110000" WHEN Ain ="0001" ELSE --1
          NOT "1101101" WHEN Ain ="0010" ELSE --2
          NOT "1111001" WHEN Ain ="0011" ELSE --3
          NOT "0110011" WHEN Ain ="0100" ELSE --4
          NOT "1011011" WHEN Ain ="0101" ELSE --5
          NOT "1011111" WHEN Ain ="0110" ELSE --6
          NOT "1110000" WHEN Ain ="0111" ELSE --7
          NOT "1111111" WHEN Ain ="1000" ELSE --8
          NOT "1110011" WHEN Ain ="1001" ELSE --9
          NOT "1101111"; -- e for error

END Structural;
