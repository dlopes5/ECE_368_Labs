------LIBRARY----------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-------ENTITY-----------
ENTITY my_Structural_nBit_RCA IS 
    GENERIC(n: INTEGER := 4);
    PORT(
          A: IN SIGNED(n-1 DOWNTO 0);
          B: IN SIGNED(n-1 DOWNTO 0); 
         C0: IN STD_LOGIC; 
          S: OUT SIGNED(n-1 DOWNTO 0); 
         OV: OUT STD_LOGIC; 
         C4: OUT STD_LOGIC 
        );
END my_STRUCTURAL_nBit_RCA;

------ARCHITECTURE-------
ARCHITECTURE my_arch OF my_Structural_nBit_RCA IS 
    COMPONENT my_full_adder IS 
        PORT( 
              a: IN STD_LOGIC; 
              b: IN STD_LOGIC; 
            cin: IN STD_LOGIC; 
              S: OUT STD_LOGIC; 
              C: OUT STD_LOGIC
            );
    END COMPONENT;
    
    SIGNAL C: STD_LOGIC_VECTOR(n DOWNTO 0);

    BEGIN 
        C(0) <= C0;
        GEN: FOR i IN 0 TO n-1 GENERATE 
             U: my_full_adder PORT MAP( A(i), B(i), C(i), S(i), C(i+1));
        END GENERATE;
        C4 <= C(n);
        OV <= '0' WHEN (C(n)=C(n-1)) ELSE 
              '1';
END my_arch;