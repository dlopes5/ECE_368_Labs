-----------LIBRARY-------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------ENTITY---------
ENTITY tb_my_Structural_nBit_RCA IS 
END tb_my_Structural_nBit_RCA;

-------ARCHITECTURE-------
ARCHITECTURE my_arch OF tb_my_Structural_nBit_RCA IS 

CONSTANT n: INTEGER :=4;

COMPONENT my_Structural_nBit_RCA
    GENERIC( n: INTEGER := n);
    PORT( 
          A: IN SIGNED(n-1 DOWNTO 0); 
          B: IN SIGNED(n-1 DOWNTO 0); 
         C0: IN STD_LOGIC; 
          S: OUT SIGNED(n-1 DOWNTO 0); 
         OV: OUT STD_LOGIC; 
         C4: OUT STD_LOGIC
        );
END COMPONENT;

SIGNAL A: SIGNED(n-1 DOWNTO 0) := "1010"; --is there a way to make this even more general. instead of the '0101' can I put an int that would convert to a binary number?
SIGNAL B: SIGNED(n-1 DOWNTO 0) := "1111";
SIGNAL C0: STD_LOGIC :='0';
SIGNAL S: SIGNED(n-1 DOWNTO 0);
SIGNAL C4: STD_LOGIC;
SIGNAL OV: STD_LOGIC;

BEGIN 
    U1: my_Structural_nBit_RCA GENERIC MAP(n => n) PORT MAP( A=> A, B=>B, C0=>C0, S=>S, C4=>C4, OV=>OV);

    PROCESS 
        BEGIN
            wait for 100 ns;
            A <= "0001"; B <= "0001"; C0 <= '0';
            wait for 100 ns;
            A <= "0001"; B <= "0001"; C0 <= '1';
            wait for 100 ns;
            A <= "0101"; B <= "0110"; C0 <= '0';
            wait for 100 ns;
            A <= "1101"; B <= "1101"; C0 <= '0';
            wait for 100 ns;
            A <= "0111"; B <= "0111"; C0 <= '0';
            wait for 100 ns;
    END PROCESS;
END my_arch;