----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:11 04/04/2014 
-- Design Name: 
-- Module Name:    memoriaRAM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
-- Memoria RAM de 128 oalabras de 32 bits
entity RAM_128_32 is port (
			CLK : in std_logic;
			ADDR : in std_logic_vector (31 downto 0); --Dir 
			Din : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
			WE : in std_logic;		-- write enable	
			RE : in std_logic;		-- read enable		  
			enable: in std_logic; --solo se lee o escribe si enable está activado
			Dout : out std_logic_vector (31 downto 0));
end RAM_128_32;

architecture Behavioral of RAM_128_32 is
type RamType is array(0 to 127) of std_logic_vector(31 downto 0);

-- DATOS 1
signal RAM : RamType := (           X"00000001", X"00000000", X"00000000", X"00000000", X"00000001", X"00000000", X"00000000", X"00000000", -- word 0,1,2,3,4,5,6,7
									X"00000001", X"00000000", X"00000000", X"00000000", X"00000001", X"00000000", X"00000000", X"00000000", --word 8,...
									X"00000001", X"00000000", X"00000000", X"00000000", X"00000001", X"00000000", X"00000000", X"00000000",--word 16,...
									X"00000001", X"00000000", X"00000000", X"00000000", X"00000001", X"00000000", X"00000000", X"00000000",--word 24,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 32,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 40,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 48,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 56,...
									X"10000000", X"00000AB0", X"01000000", X"0BAD0C0D", X"00000000", X"00000000", X"00000000", X"00000000",--word 64,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 72,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 80,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 88,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 96,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 104,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 112,...
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000");--word 120,...
	

-- DATOS 2							
--signal RAM : RamType := (           X"00000001", X"10000004", X"00000004", X"00000008", X"00000001", X"00000002", X"00000005", X"00000000", -- word 0,1,2,3,4,5,6,7
--									X"00000100", X"00000000", X"00000000", X"00000000", X"00000300", X"00000400", X"00000500", X"00000000", --word 8,...
--									X"00000009", X"00000010", X"00000020", X"00008000", X"00000600", X"00000700", X"00000800", X"00000900",--word 16,...
--									X"00000001", X"00000000", X"00000000", X"00000000", X"00000001", X"00000000", X"00000000", X"00000000",--word 24,...
--									X"00000600", X"00000700", X"00002800", X"00002900", X"00000000", X"00000000", X"00000000", X"00000000",--word 32,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 40,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 48,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 56,...
--									X"10000000", X"00000AB0", X"01000000", X"0BAD0C0D", X"00000000", X"00000000", X"00000000", X"00000000",--word 64,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 72,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 80,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 88,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 96,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 104,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",--word 112,...
--									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000");--word 120,...
signal dir_7:  std_logic_vector(6 downto 0); 
begin
 
 dir_7 <= ADDR(8 downto 2); -- como la memoria es de 128 plalabras no usamos la dirección completa sino sólo 7 bits. Como se direccionan los bytes, pero damos palabras no usamos los 2 bits menos significativos
 process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (WE = '1') and (enable = '1')then -- sólo se escribe si WE vale 1
                RAM(conv_integer(dir_7)) <= Din;
				report "Simulation time : " & time'IMAGE(now) & ".  Data written: " & integer'image(to_integer(unsigned(Din))) & ", in ADDR = " & integer'image(to_integer(unsigned(ADDR)));
            end if;
        end if;
    end process;

    Dout <= RAM(conv_integer(dir_7)) when ((RE='1') and (enable = '1')) else "00000000000000000000000000000000"; --sólo se lee si RE vale 1

end Behavioral;

