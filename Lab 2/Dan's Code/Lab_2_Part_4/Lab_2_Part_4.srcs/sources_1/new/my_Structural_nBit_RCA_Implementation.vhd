-------LIBRARY-----------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; --to get unsigned, and signed. use this one instead of arith since this one is verified
--USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; -- So I can use + and - arithmetic operations

--------ENTITY-----------
ENTITY my_4Bit_RCA_Implementation IS 
    GENERIC(
             n: INTEGER :=4 
           );
    PORT(
           --CLK100MHZ: IN STD_LOGIC;  
           A: IN SIGNED(n-1 DOWNTO 0);
           B: IN SIGNED(n-1 DOWNTO 0);
          C0: IN STD_LOGIC;
           S: OUT SIGNED(n-1 DOWNTO 0);
          OV: OUT STD_LOGIC;
          C4: OUT STD_LOGIC;
          AnodeEn: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          MasterDisp: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
END my_4Bit_RCA_Implementation;

---------ARCHITECTURE---------
ARCHITECTURE my_arch OF my_4Bit_RCA_Implementation IS 

    COMPONENT my_Structural_nBit_RCA IS 
        GENERIC(
                 n: INTEGER :=n 
               );
        PORT(
          A: IN SIGNED(n-1 DOWNTO 0);
          B: IN SIGNED(n-1 DOWNTO 0); 
         C0: IN STD_LOGIC; 
          S: OUT SIGNED(n-1 DOWNTO 0); 
         OV: INOUT STD_LOGIC; 
         C4: INOUT STD_LOGIC 
        );
     END COMPONENT;
        
    COMPONENT my_BCD_Converter IS 
        PORT ( 
                Ain: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
                --AnodeEn: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                a : OUT STD_LOGIC;
                b : OUT STD_LOGIC;
                c : OUT STD_LOGIC;
                d : OUT STD_LOGIC;
                e : OUT STD_LOGIC;
                f : OUT STD_LOGIC;
                g : OUT STD_LOGIC
             );
    END COMPONENT;

    --TYPE ONE_D_ARRAY IS ARRAY(7 DOWNTO 0) OF STD_LOGIC_VECTOR(6 DOWNTO 0);

    SIGNAL Sabs: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL OVpad: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL C4pad: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    --SIGNAL AnodeEn: BIT_VECTOR(7 DOWNTO 0) :="11111110";
    SIGNAL OVDisp: STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL C4Disp: STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL SDisp: STD_LOGIC_VECTOR(6 DOWNTO 0);
    --SIGNAL MasterDisp: ONE_D_ARRAY;
    SIGNAL IsNeg: STD_LOGIC;
    SIGNAL Off: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1111111";
    SIGNAL NegSign: STD_LOGIC_VECTOR(6 DOWNTO 0);
    --SIGNAL MasterDisp: STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL OVout: STD_LOGIC;
    SIGNAL C4out: STD_LOGIC;
    SIGNAL Sout: SIGNED(3 DOWNTO 0);
    SIGNAL CLK_Counter: INTEGER :=0;
    
    CONSTANT CLK_Freq: INTEGER :=100e6;
    CONSTANT CLK_Period: TIME:= 1000ms/CLK_Freq;
    
    SIGNAL CLK : STD_LOGIC := '1';
  
BEGIN 
    Adder: my_Structural_nBit_RCA GENERIC MAP(n =>n) PORT MAP(A=>A, B=>B, C0=>C0, S=>Sout, OV =>OVout , C4=>C4out);
    C4 <=C4out;
    OV <= OVout;
    S <= Sout;
    OVpad <= "000" & OVout;
    C4pad <= "000" & C4out;
    IsNeg <= '1' WHEN (Sout(n-1)= '1') ELSE 
             '0';
    NegSign <= "1111110" WHEN (IsNeg='1') ELSE
               Off;
    --Sabs <= STD_LOGIC_VECTOR(UNSIGNED(Sout)); 
    Sabs <= (NOT STD_LOGIC_VECTOR(Sout))+ "0001" WHEN (Sout(n-1)='1') ELSE 
            STD_LOGIC_VECTOR(Sout);
    Over: my_BCD_Converter PORT MAP( OVpad, OVDisp(6), OVDisp(5), OVDisp(4), OVDisp(3), OVDisp(2), OVDisp(1), OVDisp(0));
    OVDisp <= (OVDisp(6), OVDisp(5), OVDisp(4), OVDisp(3), OVDisp(2), OVDisp(1), OVDisp(0));
    
    Carry: my_BCD_Converter PORT MAP( C4pad, C4Disp(6), C4Disp(5), C4Disp(4), C4Disp(3), C4Disp(2), C4Disp(1), C4Disp(0));
    C4Disp <= (C4Disp(6), C4Disp(5), C4Disp(4), C4Disp(3), C4Disp(2), C4Disp(1), C4Disp(0));
    
    Sum: my_BCD_Converter PORT MAP( Sabs, SDisp(6), SDisp(5), SDisp(4), SDisp(3), SDisp(2), SDisp(1), SDisp(0));
    SDisp <= (SDisp(6), SDisp(5), SDisp(4), SDisp(3), SDisp(2), SDisp(1), SDisp(0));
   
    --MasterDisp <= ( OVDisp, Off, Off, C4Disp, Off, Off, NegSign, SDisp);
    --AnodeEn <= AnodeEn ROL 1;
    --MasterDisp <= OVDisp WHEN AnodeEn="01111111" ELSE 
    --              C4Disp WHEN AnodeEn="11101111" ELSE 
    --              NegSign WHEN AnodeEn="1111101" ELSE 
    --              SDisp WHEN AnodeEn="11111110";
    
CLK <= NOT CLK AFTER CLK_Period/2;

    PROCESS(CLK)
        BEGIN 
            IF(CLK_COUNTER=1600000) THEN 
                CLK_Counter <= 0;
            ELSIF (RISING_EDGE(CLK)) THEN
                CLK_Counter <= CLK_Counter + 1;
            END IF; 
    END PROCESS;
    
    PROCESS(CLK_Counter)
        BEGIN 
            CASE CLK_Counter IS 
                WHEN 200000 => 
                    AnodeEn <= "11111110";
                    MasterDisp <= SDisp;
                WHEN 400000 => 
                    AnodeEn <= "11111101";
                    MasterDisp <= Off;
                    --MasterDisp <= NegSign;
                WHEN 600000 => 
                    AnodeEn <= "11111011";
                    MasterDisp <= NegSign;                    
                WHEN 800000 => 
                    AnodeEn <= "11110111";
                    MasterDisp <= Off;                    
                 WHEN 1000000 => 
                    AnodeEn <= "11101111";
                    MasterDisp <=C4Disp;
                WHEN 1200000 => 
                    AnodeEn <= "11011111";
                    MasterDisp <= Off;                    
                WHEN 1400000 => 
                    AnodeEn <= "10111111";
                    MasterDisp <= OVDisp;
                    --MasterDisp <= Off;                    
                WHEN 1600000 => 
                    AnodeEn <= "01111111";
                    MasterDisp <=Off;
                    --MasterDisp <= OVDisp;
                    --CLK_Counter <= 0;
                WHEN OTHERS =>
           END CASE;
     END PROCESS;                                   
           
END my_arch;