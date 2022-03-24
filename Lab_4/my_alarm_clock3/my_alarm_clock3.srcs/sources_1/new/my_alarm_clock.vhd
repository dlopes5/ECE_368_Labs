library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity my_alarm_clock is
    PORT(
            CLK100MHZ: IN STD_LOGIC;
            btn_clk_set: IN STD_LOGIC;
            btn_alrm_set: IN STD_LOGIC;
            btn_hr_set: IN STD_LOGIC;
            btn_min_set: IN STD_LOGIC;
            sw_alrm: IN STD_LOGIC;
            sw_rst: IN STD_LOGIC;
            LED_alrm_on: OUT STD_LOGIC;
            LED_am_pm: OUT STD_LOGIC;
            LED_alrm_alert: OUT STD_LOGIC;
            SSD_AnodeEn: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --only the left 6 are being used
            SSD_SegPattern: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        ); 
end my_alarm_clock;

architecture Behavioral of my_alarm_clock is

SIGNAL sec: NATURAL RANGE 0 TO 59:=0;
SIGNAL min: NATURAL RANGE 0 TO 59:=0;
SIGNAL hr: NATURAL RANGE 1 TO 12:=12;

SIGNAL alrm_min_sig: NATURAL RANGE 0 TO 59:=0;
SIGNAL alrm_hr_sig: NATURAL RANGE 1 TO 12:=12;
--component declarations
COMPONENT my_BCD_Converter IS 
    PORT ( 
           Ain: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
           SegPatternOut: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
           );
END COMPONENT;

COMPONENT dff IS
        port( 
                d: in std_logic;
                clk: in std_logic;
                rst: in std_logic;
                q: out std_logic;
                qnot: out std_logic
             );  
END COMPONENT;

TYPE my_SSD_patterns IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR(6 DOWNTO 0);-- used to hold all segment patterns for each of the 6 digits

SIGNAL am_pm: std_logic:='0';

--SIGNALS for the 8 seperate Digits
SIGNAL sec_1sDigit: NATURAL RANGE 0 TO 9;
SIGNAL sec_10sDigit: NATURAL RANGE 0 TO 9;
SIGNAL min_1sDigit: NATURAL RANGE 0 TO 9;
SIGNAL min_10sDigit: NATURAL RANGE 0 TO 9;
SIGNAL hr_1sDigit: NATURAL RANGE 0 TO 9;
SIGNAL hr_10sDigit: NATURAL RANGE 0 TO 9;

SIGNAL STD_sec_1sDigit: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_sec_10sDigit: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_min_1sDigit: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_min_10sDigit: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_hr_1sDigit: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_hr_10sDigit: STD_LOGIC_VECTOR(3 DOWNTO 0);

--signals for the 8 seperate digits for the alrm time display 
SIGNAL min_1sDigit_alrm: NATURAL RANGE 0 TO 9;
SIGNAL min_10sDigit_alrm: NATURAL RANGE 0 TO 9;
SIGNAL hr_1sDigit_alrm: NATURAL RANGE 0 TO 9;
SIGNAL hr_10sDigit_alrm: NATURAL RANGE 0 TO 9;

SIGNAL STD_min_1sDigit_alrm: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_min_10sDigit_alrm: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_hr_1sDigit_alrm: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL STD_hr_10sDigit_alrm: STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL SSD_pattern_collection: my_SSD_patterns;
SIGNAL SSD_pattern_collection_alrm: my_SSD_patterns;

signal disp_alrm_on_sig: std_logic:='0';
signal am_pm_alrm_sig: std_logic:='0';



--sigs for debounced btn signals 
signal clk_set: STD_LOGIC:='0';
signal min_set: STD_LOGIC:='0';
signal hr_set: STD_LOGIC:='0';
signal CLK10MS: std_logic:='0';

signal alrm_on: std_logic:='0';
signal alrm_set:std_logic:='0';
 begin

--Seperate the Digits from the time numbers 
sec_1sDigit<=sec MOD 10;
sec_10sDigit<=(sec/10) MOD 10;
min_1sDigit<=min MOD 10;
min_10sDigit<=(min/10) MOD 10;
hr_1sDigit<=hr MOD 10;
hr_10sDigit<=(hr/10) MOD 10;

--Convert from natural to STD_LOGIC
STD_sec_1sDigit<=STD_LOGIC_VECTOR(TO_UNSIGNED(sec_1sDigit, STD_sec_1sDigit'LENGTH));
STD_sec_10sDigit<=STD_LOGIC_VECTOR(TO_UNSIGNED(sec_10sDigit, STD_sec_10sDigit'LENGTH));
STD_min_1sDigit<=STD_LOGIC_VECTOR(TO_UNSIGNED(min_1sDigit, STD_min_1sDigit'LENGTH));
STD_min_10sDigit<=STD_LOGIC_VECTOR(TO_UNSIGNED(min_10sDigit, STD_min_10sDigit'LENGTH));
STD_hr_1sDigit<=STD_LOGIC_VECTOR(TO_UNSIGNED(hr_1sDigit, STD_hr_1sDigit'LENGTH));
STD_hr_10sDigit<=STD_LOGIC_VECTOR(TO_UNSIGNED(hr_10sDigit, STD_hr_10sDigit'LENGTH));

--Get the segment patters for each digit
Digit7: my_BCD_Converter PORT MAP (Ain=>STD_hr_10sDigit,SegPatternOut=>SSD_pattern_collection(7));
Digit6: my_BCD_Converter PORT MAP (Ain=>STD_hr_1sDigit,SegPatternOut=>SSD_pattern_collection(6));
Digit5: my_BCD_Converter PORT MAP (Ain=>STD_min_10sDigit,SegPatternOut=>SSD_pattern_collection(5));
Digit4: my_BCD_Converter PORT MAP (Ain=>STD_min_1sDigit,SegPatternOut=>SSD_pattern_collection(4));
Digit3: my_BCD_Converter PORT MAP (Ain=>STD_sec_10sDigit,SegPatternOut=>SSD_pattern_collection(3));
Digit2: my_BCD_Converter PORT MAP (Ain=>STD_sec_1sDigit,SegPatternOut=>SSD_pattern_collection(2));
SSD_pattern_collection(1)<="1111111";--segment is off
SSD_pattern_collection(0)<="1111111";--segment is off



-----------------this is for getting the individual digits of the alrm time displayed on the SSDs 
--Seperate the Digits from the time numbers 
min_1sDigit_alrm<=alrm_min_sig MOD 10;
min_10sDigit_alrm<=(alrm_min_sig/10) MOD 10;
hr_1sDigit_alrm<=alrm_hr_sig MOD 10;
hr_10sDigit_alrm<=(alrm_hr_sig/10) MOD 10;

-- convert the digits from natural to std_logic
STD_min_1sDigit_alrm<=STD_LOGIC_VECTOR(TO_UNSIGNED(min_1sDigit_alrm, STD_min_1sDigit_alrm'LENGTH));
STD_min_10sDigit_alrm<=STD_LOGIC_VECTOR(TO_UNSIGNED(min_10sDigit_alrm, STD_min_10sDigit_alrm'LENGTH));
STD_hr_1sDigit_alrm<=STD_LOGIC_VECTOR(TO_UNSIGNED(hr_1sDigit_alrm, STD_hr_1sDigit_alrm'LENGTH));
STD_hr_10sDigit_alrm<=STD_LOGIC_VECTOR(TO_UNSIGNED(hr_10sDigit_alrm, STD_hr_10sDigit_alrm'LENGTH));

--Get the segment patters for each digit
Digit7alrm: my_BCD_Converter PORT MAP (Ain=>STD_hr_10sDigit_alrm,SegPatternOut=>SSD_pattern_collection_alrm(7));
Digit6alrm: my_BCD_Converter PORT MAP (Ain=>STD_hr_1sDigit_alrm,SegPatternOut=>SSD_pattern_collection_alrm(6));
Digit5alrm: my_BCD_Converter PORT MAP (Ain=>STD_min_10sDigit_alrm,SegPatternOut=>SSD_pattern_collection_alrm(5));
Digit4alrm: my_BCD_Converter PORT MAP (Ain=>STD_min_1sDigit_alrm,SegPatternOut=>SSD_pattern_collection_alrm(4));
SSD_pattern_collection_alrm(3)<=not"1111110";--segment 0 since we can't set the seconds of the alrm
SSD_pattern_collection_alrm(2)<=not"1111110";--segment 0 since we can't set the seconds of the alrm
SSD_pattern_collection_alrm(1)<="1111111";--segment is off
SSD_pattern_collection_alrm(0)<="1111111";--segment is off

--dff that will debounce the buttons!!!!
dff_clk_set: dff PORT MAP(btn_clk_set, CLK10MS, sw_rst, clk_set);   
dff_min_set: dff PORT MAP(btn_min_set, CLK10MS, sw_rst, min_set);
dff_hr_set: dff PORT MAP(btn_hr_set, CLK10MS, sw_rst, hr_set); 
dff_alrm_set: dff PORT MAP(btn_alrm_set,CLK10MS,sw_rst,alrm_set);


LED_am_pm<=am_pm when disp_alrm_on_sig='0' else -- when the alrm set button isnt pressed ie disp_alrm_on_sig=1 then just display the time of day currently
           am_pm_alrm_sig; -- if the alrm set button is pressed then show the appropriate time of day for the alrm time.
LED_alrm_on<=sw_alrm;
LED_alrm_alert<=alrm_on;

process(CLK100MHZ)
    variable cnt1sec: natural range 0 to 100000000;
    variable sec_var: natural range 0 to 60;
    variable min_var: natural range 0 to 60;
    variable  hr_var: natural range 1 to 13;
    variable  am_pm_var:std_logic:='0';--0 for AM, 1 for PM
    
    variable cnt_SSD_refresh: natural range 0 to 1800000;

    variable cnt_clk10ms: natural range 0 to 1000000:=0;
    
    --vars for the alarm 
    variable alrm_hr: natural range 1 to 12:=12;
    variable alrm_min: natural range 0 to 59:=1;
    variable alrm_am_pm: std_logic:='0';
    variable alrm_on_var: std_logic:='0';
    variable cnt_btn_hr: natural range 0 to 50000000;--for half a sec delay for buttons
    variable cnt_btn_min: natural range 0 to 50000000;--for half a sec delay for buttons
    variable cnt_btn_hr_alrm: natural range 0 to 50000000;-- for the delay when alrm and hr is pressed
    variable cnt_btn_min_alrm: natural range 0 to 50000000;-- for the delay when alrm and min is pressed
    variable disp_alrm: std_logic:='0'; 
    
     
    begin
        if CLK100MHZ'event and CLK100MHZ='1' then 
            cnt1sec:=cnt1sec+1;
            if cnt1sec=100000000 then
                cnt1sec:=0;
                sec_var:=sec_var+1;
                if sec_var=60 then --roll over sec
                    sec_var:=0;
                    min_var:=min_var+1;
                    if min_var=60 then -- roll over min
                        min_var:=0;
                        hr_var:=hr_var+1;
                        if hr_var=11 then
                            am_pm_var:=not am_pm_var;--invert whatever time of day it is 
                        end if;
                        if hr_var=13 then --roll over hr
                            hr_var:=1;
                        end if;     
                    end if;
                end if; 
            end if;
            
            if sw_rst='1' then --reset back to 12:00:00 am if sw is active
                sec_var:=0;
                min_var:=0;
                hr_var:=12;
                am_pm_var:='0';
                cnt1sec:=0;--reset the 1 second counter
                --now reset the alrm back to 12:00:00 am like my clock does when it loses power :(
                alrm_hr:=12;
                alrm_min:=0; 
                alrm_am_pm:='0';
            end if;
            
            --counter for 10ms clock for the button debounce 
            cnt_clk10ms:=cnt_clk10ms+1;
            if cnt_clk10ms=500000 then
                 CLK10MS<='1';
            end if;
            if cnt_clk10ms=1000000 then 
                CLK10MS<='0';
                cnt_clk10ms:=0;
            end if;
           
                            
           if clk_set='1' and hr_set='1' then 
                cnt_btn_hr:=cnt_btn_hr+1;
                if cnt_btn_hr=50000000 then 
                    IF hr_var=11 THEN 
                        am_pm_var:=not am_pm_var; -- invert whatever time of day it so so if it is pm it becomes am.
                    END IF;
                    IF hr_var=12 THEN 
                        hr_var:=1;
                    ELSE 
                        hr_var:=hr_var+1;
                    END IF;
                    cnt_btn_hr:=0;
                end if;
           end if;
           
           if clk_set='1' and min_set='1' then 
                cnt_btn_min:=cnt_btn_min+1;
                if cnt_btn_min= 50000000 then 
                    IF min_var=59 THEN 
                        min_var:=0;
                    ELSE 
                        min_var:=min_var+1;
                    END IF;
                    cnt_btn_min:=0;--reset the counter
                end if;
           end if;                                                 
            
            if clk_set='0' then
                cnt_btn_hr:=0;
                cnt_btn_min:=0;
            end if;
            if clk_set='1' then 
                sec_var:=0;
            end if;
            --alarm section 
           if alrm_set='1' and min_set='1' then 
                cnt_btn_min_alrm:=cnt_btn_min_alrm+1;
                if cnt_btn_min_alrm= 50000000 then 
                    IF alrm_min=59 THEN 
                        alrm_min:=0;
                    ELSE 
                        alrm_min:=alrm_min+1;
                    END IF;
                    cnt_btn_min_alrm:=0;--reset the counter
                end if;
           end if;
           
           if alrm_set='1' and hr_set='1' then 
                cnt_btn_hr_alrm:=cnt_btn_hr_alrm+1;
                if cnt_btn_hr_alrm=50000000 then 
                    IF alrm_hr=11 THEN 
                        alrm_am_pm:=not alrm_am_pm; -- invert whatever time of day it so so if it is pm it becomes am.
                    END IF;
                    IF alrm_hr=12 THEN 
                        alrm_hr:=1;
                    ELSE 
                        alrm_hr:=alrm_hr+1;
                    END IF;
                    cnt_btn_hr_alrm:=0;
                end if;
           end if;                
            
            if alrm_set='1' then-- if alrm button is pressed set a flag to display that time instead of the actual time
                disp_alrm:='1';
            end if;
            if alrm_set='0' then 
                cnt_btn_hr_alrm:=0;--reset the alrm button counters for the half sec delay
                cnt_btn_min_alrm:=0;
                disp_alrm:='0';-- if the alrm set button is not pressed then just display the normal time
            end if;
            
            if sw_alrm='1' and alrm_hr=hr_var and alrm_min=min_var and sec=0 and alrm_am_pm=am_pm_var then 
                alrm_on_var:='1';
            end if;
            if sw_alrm='0' and alrm_on_var='1' then 
                alrm_on_var:='0';
            end if;
                  
            
            --counter for SSD refresh rate algorithm 62.5fps
            cnt_SSD_refresh:=cnt_SSD_refresh+1;
            if cnt_SSD_refresh=1800000 then 
                cnt_SSD_refresh:=200000;
            end if;
            if disp_alrm='0' then        
                case cnt_SSD_refresh is 
                    WHEN 200000 => 
                        SSD_AnodeEn <= "11111110";
                        SSD_SegPattern <= SSD_pattern_collection(0); --off
                    WHEN 400000 => 
                        SSD_AnodeEn <= "11111101";
                        SSD_SegPattern <= SSD_pattern_collection(1); --off
                    WHEN 600000 => 
                        SSD_AnodeEn <= "11111011";
                        SSD_SegPattern <= SSD_pattern_collection(2); --sec 1s                   
                    WHEN 800000 => 
                        SSD_AnodeEn <= "11110111";
                        SSD_SegPattern <= SSD_pattern_collection(3); -- sec 10s                   
                    WHEN 1000000 => 
                        SSD_AnodeEn <= "11101111";
                        SSD_SegPattern <= SSD_pattern_collection(4);  --min 1s                  
                    WHEN 1200000 => 
                        SSD_AnodeEn <= "11011111";
                        SSD_SegPattern <= SSD_pattern_collection(5);  --min 10s                  
                    WHEN 1400000 => 
                        SSD_AnodeEn <= "10111111";
                        SSD_SegPattern <= SSD_pattern_collection(6); --hr 1s                   
                    WHEN 1600000 => 
                        SSD_AnodeEn <= "01111111";
                        SSD_SegPattern <= SSD_pattern_collection(7);  --hr 10s               
                    WHEN OTHERS => 
                        NULL;-- don't do anything in the other states
                END CASE;
             else 
                case cnt_SSD_refresh is 
                    WHEN 200000 => 
                        SSD_AnodeEn <= "11111110";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(0); --off
                    WHEN 400000 => 
                        SSD_AnodeEn <= "11111101";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(1); --off
                    WHEN 600000 => 
                        SSD_AnodeEn <= "11111011";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(2); --sec 1s                   
                    WHEN 800000 => 
                        SSD_AnodeEn <= "11110111";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(3); -- sec 10s                   
                    WHEN 1000000 => 
                        SSD_AnodeEn <= "11101111";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(4);  --min 1s                  
                    WHEN 1200000 => 
                        SSD_AnodeEn <= "11011111";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(5);  --min 10s                  
                    WHEN 1400000 => 
                        SSD_AnodeEn <= "10111111";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(6); --hr 1s                   
                    WHEN 1600000 => 
                        SSD_AnodeEn <= "01111111";
                        SSD_SegPattern <= SSD_pattern_collection_alrm(7);  --hr 10s               
                    WHEN OTHERS => 
                        NULL;-- don't do anything in the other states
                END CASE;
             end if;             
            
        END IF;--end the rising edge clk100mhz if statement
        sec<=sec_var;
        min<=min_var;
        hr<=hr_var;
        am_pm<=am_pm_var;
        alrm_on<=alrm_on_var;-- pass the alrm_on variable to a signal to get it out of the process 
        alrm_hr_sig<=alrm_hr;-- pass the alrm values to the outside signals so they can be converted to SSD and displayed when alrm set is '1'
        alrm_min_sig<=alrm_min;
        am_pm_alrm_sig<=alrm_am_pm;
        disp_alrm_on_sig<=disp_alrm; 
end process;


end Behavioral;
