library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.Gates.all;

entity sbo2 is
    port(
        sbo2out0, sbo2out1, sbo2out2, sbo2out3: out std_logic_vector(31 downto 0);
        sbo2in0, sbo2in1, sbo2in2, sbo2in3, sbo2in4, sbo2in5, sbo2in6, sbo2in7: in std_logic_vector(31 downto 0);
        write_en, clk,rst: in std_logic
    );
end entity sbo2;

architecture arc of sbo2 is
    type arr is array (0 to 7) of std_logic_vector(31 downto 0);
    signal data0, data1, data2, data3, old0, old1, old2, old3: arr := (others => (others => '0'));
    signal write_count: integer  := 0;
    signal add_cycle: integer  := 0;
    signal sum0, sum1, sum2, sum3: std_logic_vector(31 downto 0) := (others => '0');
    signal c0, c1, c2, c3: std_logic := '0';
begin

    adder0: Adder32
        port map (
            A => data0(0),
            B => old0(0),
            Sum => sum0,
            CarryOut => c0
        );

    adder1: Adder32
        port map (
            A => data1(0),
            B => old1(0),
            Sum => sum1,
            CarryOut => c1
        );

    adder2: Adder32
        port map (
            A => data2(0),
            B => old2(0),
            Sum => sum2,
            CarryOut => c2
        );

    adder3: Adder32
        port map (
            A => data3(0),
            B => old3(0),
            Sum => sum3,
            CarryOut => c3
        );

    sbo2out0 <= sum0;
    sbo2out1 <= sum1;
    sbo2out2 <= sum2;
    sbo2out3 <= sum3;

process(rst,clk,sbo2in0, sbo2in1, sbo2in2, sbo2in3, sbo2in4, sbo2in5, sbo2in6, sbo2in7,write_en)
begin
if rising_edge(clk) then
if(rst='1') then
		  old0(0) <= x"6a09e667";  -- H(0)
		  old0(1) <= x"bb67ae85";  -- H(1)
		  old0(2) <= x"3c6ef372";  -- H(2)
		  old0(3) <= x"a54ff53a";  -- H(3)	
		  old0(4) <= x"510e527f";  -- H(4)
   	  old0(5) <= x"9b05688c";  -- H(5)
		  old0(6) <= x"1f83d9ab";  -- H(6)
		  old0(7) <= x"5be0cd19";  -- H(7)
						
						  -- Initialize old1
        old1(0) <= x"6a09e667";  -- H(0)
        old1(1) <= x"bb67ae85";  -- H(1)
        old1(2) <= x"3c6ef372";  -- H(2)
        old1(3) <= x"a54ff53a";  -- H(3)
        old1(4) <= x"510e527f";  -- H(4)
        old1(5) <= x"9b05688c";  -- H(5)
        old1(6) <= x"1f83d9ab";  -- H(6)
        old1(7) <= x"5be0cd19";  -- H(7)
        
        -- Initialize old2
        old2(0) <= x"6a09e667";  -- H(0)
        old2(1) <= x"bb67ae85";  -- H(1)
        old2(2) <= x"3c6ef372";  -- H(2)
        old2(3) <= x"a54ff53a";  -- H(3)
        old2(4) <= x"510e527f";  -- H(4)
        old2(5) <= x"9b05688c";  -- H(5)
        old2(6) <= x"1f83d9ab";  -- H(6)
        old2(7) <= x"5be0cd19";  -- H(7)
        
        -- Initialize old3
        old3(0) <= x"6a09e667";  -- H(0)
        old3(1) <= x"bb67ae85";  -- H(1)
        old3(2) <= x"3c6ef372";  -- H(2)
        old3(3) <= x"a54ff53a";  -- H(3)
        old3(4) <= x"510e527f";  -- H(4)
        old3(5) <= x"9b05688c";  -- H(5)
        old3(6) <= x"1f83d9ab";  -- H(6)
        old3(7) <= x"5be0cd19";  -- H(7)
		  write_count<=0;
        else 
 
		    if write_en = '1' then
                    case write_count is
                        when 0 =>
                            data0(0) <= sbo2in0;
                            data0(1) <= sbo2in1;
                            data0(2) <= sbo2in2;
                            data0(3) <= sbo2in3;
                            data0(4) <= sbo2in4;
                            data0(5) <= sbo2in5;
                            data0(6) <= sbo2in6;
                            data0(7) <= sbo2in7;
                        when 1 =>
                            data1(0) <= sbo2in0;
                            data1(1) <= sbo2in1;
                            data1(2) <= sbo2in2;
                            data1(3) <= sbo2in3;
                            data1(4) <= sbo2in4;
                            data1(5) <= sbo2in5;
                            data1(6) <= sbo2in6;
                            data1(7) <= sbo2in7;
                        when 2 =>
                            data2(0) <= sbo2in0;
                            data2(1) <= sbo2in1;
                            data2(2) <= sbo2in2;
                            data2(3) <= sbo2in3;
                            data2(4) <= sbo2in4;
                            data2(5) <= sbo2in5;
                            data2(6) <= sbo2in6;
                            data2(7) <= sbo2in7;
                        when 3 =>
                            data3(0) <= sbo2in0;
                            data3(1) <= sbo2in1;
                            data3(2) <= sbo2in2;
                            data3(3) <= sbo2in3;
                            data3(4) <= sbo2in4;
                            data3(5) <= sbo2in5;
                            data3(6) <= sbo2in6;
                            data3(7) <= sbo2in7;
								when others=>
                    end case;
                    write_count <= write_count + 1;    
                end if;

            -- Data shifting logic
            if (write_en = '0' and write_count>3)then
                for i in 0 to 6 loop
                    old0(i) <= old0(i + 1);
                    old1(i) <= old1(i + 1);
                    old2(i) <= old2(i + 1);
                    old3(i) <= old3(i + 1);

                    data0(i) <= data0(i + 1);
                    data1(i) <= data1(i + 1);
                    data2(i) <= data2(i + 1);
                    data3(i) <= data3(i + 1);
                end loop;
            end if;
		   end if;
		 end if;
    end process;

end architecture arc;