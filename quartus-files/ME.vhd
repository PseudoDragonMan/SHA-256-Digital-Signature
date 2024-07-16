library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.Gates.all;

-- Entity for 32-bit Adder
entity ME is
    Port ( clk:in std_logic;
	        counter : in  std_logic_vector(9 downto 0);  
	        Wj,Wj2,Wj7,Wj16,Wj15: in  STD_LOGIC_VECTOR(31 downto 0);
           Wout : out  STD_LOGIC_VECTOR(31 downto 0);
			  Waddr:out std_logic_vector(5 downto 0);
			  sel:out std_logic_vector(1 downto 0)
           );
end entity;


architecture Behavioral of ME is
signal sigma0,sigma1,a,b,c,d,e,f,sum1,sum2,sum3:STD_LOGIC_VECTOR(31 downto 0);
signal l11,l12,l13,l21:STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal c1,c2,c3:std_logic;
signal count,counterl1,diva,rema,divi:integer:=0;
begin
count<=to_integer(unsigned(counter));
a<=Wj15(6 downto 0) & Wj15(31 downto 7);
b<=Wj15(17 downto 0) & Wj15(31 downto 18);		  
c<="000" & Wj15(31 downto 3);
			  
sigma0<=((a xor b) xor c);

d<=Wj2(16 downto 0) & Wj2(31 downto 17);
			  
e<=Wj2(18 downto 0) & Wj2(31 downto 19);
			  
f<="0000000000" & Wj2(31 downto 10);
			  
sigma1<=((d xor e) xor f);


adder1:Adder32 
    Port map ( A =>sigma0,
           B =>Wj16,
           Sum =>sum1,
           CarryOut=>c1);
			  
adder2:Adder32 
    Port map ( A =>sigma1,
           B =>Wj7,
           Sum =>sum2,
           CarryOut=>c2);
adder3:Adder32 
    Port map ( A =>l11,
           B =>l12,
           Sum =>sum3,
           CarryOut=>c3);
Wout<=l21;

diva<=(counterl1/4);
divi<=(counterl1-1)/4;
rema<=(counterl1+1) rem 4;
waddr<=std_logic_vector(to_unsigned(divi,6));

sel<=std_logic_vector(to_unsigned(rema,2));

 process (Wj,Wj2,Wj7,Wj16,Wj15,clk,count,sum1,sum2)
 begin
 if rising_edge(clk) then
 if((divi
 ) < 16 ) then
   l21<=l13;
  else
   l21<=sum3;
  end if;
  l13<=Wj;
  l11<=sum1;
  l12<=sum2;
  counterl1<=count;
  end if;  
 end process;
end Behavioral;