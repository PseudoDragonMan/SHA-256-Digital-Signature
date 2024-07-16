library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity sbi1 is
    port(
        sbi1out1,sbi1out2,sbi1out3,sbi1out0: out std_logic_vector(31 downto 0);
        sbi1in1,sbi1in2,sbi1in3,sbi1in0: in std_logic_vector(31 downto 0);
        write_en, clk, rst: in std_logic;
		  sbi1_r: in std_logic_vector(1 downto 0)
    );
end entity sbi1;

architecture arc of sbi1 is
    type arr is array (0 to 3) of std_logic_vector(31 downto 0);

    signal data0,data1,data2,data3: arr:=(others=>"00000000000000000000000000000000");
	 
begin

    process(clk,rst,data0,data1,data2,data3,write_en,sbi1_r) 
    begin
        if rst = '1' then
            for i in 0 to 3 loop
                data0(i) <= "00000000000000000000000000000000";
					 data1(i) <= "00000000000000000000000000000000";
					 data2(i) <= "00000000000000000000000000000000";
					 data3(i) <= "00000000000000000000000000000000";
				    
            end loop;
        elsif rising_edge(clk) then
            if write_en = '1' then
                data0(3) <= data0(2);
					 data0(2) <= data0(1);
					 data0(1) <= data0(0);
					 data0(0) <= sbi1in0;
					 
					 data1(3) <= data1(2);
					 data1(2) <= data1(1);
					 data1(1) <= data1(0);
					 data1(0) <= sbi1in1;
					 
					 data2(3) <= data2(2);
					 data2(2) <= data2(1);
					 data2(1) <= data2(0);
					 data2(0) <= sbi1in2;
					 
					 data3(3) <= data3(2);
					 data3(2) <= data3(1);
					 data3(1) <= data3(0);
					 data3(0) <= sbi1in3;
            end if;	
				end if;
				
				case sbi1_r is 
				
					when "00" =>
								
						 sbi1out3 <= data0(3);
						 sbi1out2 <= data0(2);
						 sbi1out1 <= data0(1);
						 sbi1out0 <= data0(0);	
						
					when "01" =>
								
						 sbi1out3 <= data1(3);
						 sbi1out2 <= data1(2);
						 sbi1out1 <= data1(1);
						 sbi1out0 <= data1(0);	
						 
					when "10" =>
								
						 sbi1out3 <= data2(3);
						 sbi1out2 <= data2(2);
						 sbi1out1 <= data2(1);
						 sbi1out0 <= data2(0);	
						 
					when "11" =>
								
						 sbi1out3 <= data3(3);
						 sbi1out2 <= data3(2);
						 sbi1out1 <= data3(1);
						 sbi1out0 <= data3(0);	
						 
					when others =>
						null;
					end case;
						
        
    end process;
end architecture;