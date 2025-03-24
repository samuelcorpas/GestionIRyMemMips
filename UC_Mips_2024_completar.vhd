----------------------------------------------------------------------------------
-- Description: Unidad de Control. Las señales de las nuevas instrucciones no están completas
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port ( valid_I_ID : in  STD_LOGIC; --indica si es una instrucción válida
    	   IR_op_code : in  STD_LOGIC_VECTOR (5 downto 0);
           Branch : out  STD_LOGIC;
           RegDst : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
		   MemWrite : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           -- Señales Práctica 3
		   jal : out  STD_LOGIC; --indica que es una instrucción jal 
           ret : out  STD_LOGIC; --indica que es una instrucción ret
		   undef: out STD_LOGIC; --indica que el código de operación no pertenence a una instrucción conocida. En este procesador se usa sólo para depurar
           -- Nuevas señales
		   RTE	: out  STD_LOGIC -- indica que es una instrucción RTE	   
		   -- Fin Nuevas señales
		   );
end UC;

architecture Behavioral of UC is
-- Constantes para mejorar la legibilidad del código
CONSTANT NOP_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000000";
CONSTANT ARIT_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000001";
CONSTANT LW_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000010";
CONSTANT SW_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000011";
CONSTANT BEQ_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000100";
CONSTANT JAL_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000101";
CONSTANT RET_opcode : STD_LOGIC_VECTOR (5 downto 0) := "000110";
CONSTANT RTE_opcode : STD_LOGIC_VECTOR (5 downto 0) := "001000";
begin
-- Si IR_op = 0 es nop, IR_op=1 es aritmética, IR_op=2 es LW, IR_op=3 es SW, IR_op= 4 es BEQ, IR_op=5 es jal, IR_op= 6 es ret, IR_op= 8 es RTE

UC_mux : process (IR_op_code, valid_I_ID)
begin 
	-- Por defecto ponemos todas las señales a 0 que es el valor que garantiza que no alteramos nada
	Branch <= '0'; RegDst <= '0'; ALUSrc <= '0'; MemWrite <= '0'; MemRead <= '0'; MemtoReg <= '0'; RegWrite <= '0'; UNDEF <= '0';
	jal <= '0'; ret <= '0'; RTE <= '0'; 
	IF valid_I_ID = '1' then --si la instrucción es válida analizamos su código de operación
		CASE IR_op_code IS
			--NOP 
			WHEN  NOP_opcode  	=>  
			--ARIT
			WHEN  ARIT_opcode  	=> 	RegDst <= '1'; RegWrite <= '1'; 
			--LW
			WHEN  LW_opcode  	=>  ALUSrc <= '1'; MemRead <= '1'; MemtoReg <= '1'; RegWrite <= '1'; 
			--SW
			WHEN  SW_opcode  	=>  ALUSrc <= '1'; MemWrite <= '1'; 
			--BEQ
			WHEN  BEQ_opcode  	=>  Branch <= '1'; 
			------------------------------------------------
			-- COMPLETAR
			------------------------------------------------
			-- JAL
			WHEN  jal_opcode  	=>  jal <= '1'; RegWrite <= '1'; RegDst <= '0'; --Branch <= '1'; --¿qué más señales?
			-- RET
			WHEN  RET_opcode  	=>  ret <= '1'; --¿qué más señales?
			--RTE
			WHEN  RTE_opcode  	=>  RTE <= '1'; --¿qué más señales?
			-- OP code undefined
			WHEN  OTHERS 	  	=> UNDEF <= '1'; --Se activa si la instrucción no pertenece al repertorio
		  END CASE;
	END IF;
end process;
end Behavioral;

