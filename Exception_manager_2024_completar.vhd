----------------------------------------------------------------------------------
-- Description: Exception_manager: se ocupa de gestionar la excepciones en el MIPS
-- Incluye soporte para IRQ, Data_Abort y Undefined
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Exception_manager is
    Port ( 	clk : in  STD_LOGIC;
           	reset : in  STD_LOGIC;
           	IRQ	: 	in  STD_LOGIC; 
           	Data_abort: in std_logic; --indica que el último acceso a memoria ha sido un error
           	undef: in STD_LOGIC; --indica que el código de operación no pertenence a una instrucción conocida. En este procesador se usa sólo para depurar
           	RTE_ID: in STD_LOGIC; -- indica que en ID hay una instrucción de retorno de Excepción válida
           	RTE_EX: in STD_LOGIC; -- indica que en EX hay una instrucción de retorno de Excepción válida
           	valid_I_ID: in STD_LOGIC; -- indica que la instrucción en ID es válida
           	valid_I_EX: in STD_LOGIC; -- indica que la instrucción en EX es válida
           	valid_I_MEM: in STD_LOGIC; -- indica que la instrucción en MEM es válida
           	parar_MIPS: in STD_LOGIC; -- indica que hay que detener todas las etapas del mips
           	PC_out: std_logic_vector(31 downto 0);-- pc actual
           	PC_exception_EX: std_logic_vector(31 downto 0); --PC de la Ins en EX
           	PC_exception_ID: std_logic_vector(31 downto 0); --PC de la Ins en ID
           	Exception_accepted: out STD_LOGIC; -- Informa que se va a ceptar un excepción en el ciclo actual
           	Exception_LR_output: out std_logic_vector(31 downto 0)
           	);         	
end Exception_manager;

architecture Behavioral of Exception_manager is

component reg is
    generic (size: natural := 32);  -- por defecto son de 32 bits, pero se puede usar cualquier tamaño
	Port ( Din : in  STD_LOGIC_VECTOR (size -1 downto 0);
           clk : in  STD_LOGIC;
	   reset : in  STD_LOGIC;
           load : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (size -1 downto 0));
end component;

-- Soporte Excepciones--
	signal MIPS_status, status_input: std_logic_vector(1 downto 0);
	signal Return_I : std_logic_vector(31 downto 0);
	signal update_status, Exception_accepted_internal: std_logic;		
	-- ****************************************************************************************************
	-- Gestión de Excepciones: 
	--		* IRQ: es una entrada del MIPs
	--		* Data_abort: la genera el controlador de memoria cuando recibe una dirección no alienada, o fuera del rango de la memoria
	--		* UNDEF: la genera la unidad de control cuando le llega una instrucción válida con un código de operación desconocido
	-- ****************************************************************************************************
	-------------------------------------------------------------------------------------------------------------------------------
	-- Status_register	 
	-- el registro tiene como entradas y salidas vectores de señales cuya longitud se indica en size. En este caso es un vector de tamaño 2
	-- El bit más significativo permite deshabilitar (valor 1) o habilitar las excepciones (valor 0)
	-- El bit menos significativo informa si estamos en modo Excepción o estamos en modo normal
Begin	
	status_reg: reg generic map (size => 2)
			port map (	Din => status_input, clk => clk, reset => reset, load => update_status, Dout => MIPS_status);
	------------------------------------------------------------------------------------
	-- Completar: falta la lógica que detecta cuándo se va a procesar una excepción: cuando se recibe una de las señales (IRQ, Data_abort y Undef) y las excepciones están habilitadas (MIPS_status(1)='0')
	-- IMPORTANTE: No hay que actualizar nada si el MIPS está parado
	
	update_status	<= '1' when ((IRQ = '1' or Data_abort = '1' or undef = '1') and (MIPS_status(1) = '0')  and (parar_MIPS = '0')) or ((RTE_ID = '1') and (MIPS_status(1) = '1') and (parar_MIPS = '0')) else '0';
	
	-- Completar:se procesa una excepción si se recibe IRQ, Abort o Undef y las excepciones están habilitadas (MIPS_status(1)='0') y el procesador no está parado (parar_MIPS = '0')
	-- se define una señal interna para poder leerla en el módulo (las señales de salida, como Exception_accepted, no se pueden leer)
	Exception_accepted_internal <= '1' when (IRQ = '1' or Data_abort = '1' or undef = '1') and (MIPS_status(1) = '0')  and (parar_MIPS = '0') else '0';
	Exception_accepted <= Exception_accepted_internal;
	-- Fin completar;
	------------------------------------------------------------------------------------
				
	-- multiplexor para elegir la entrada del registro de estado
	-- En este procesador sólo hay dos opciones ya que al entrar en modo excepción se deshabilitan las excepciones:
	-- 		* "11" al entrar en una IRQ (Excepciones deshabilitadas y modo Excepción)
	--		* "00" en el resto de casos
	-- Podría hacerse con un bit, pero usamos dos para permitir ampliaciones)
	status_input	<= 	"11" when (Exception_accepted_internal = '1') else 
				"00" ;							
	
	------------------------------------------------------------------------------------
	-- Al procesar una excepción las instrucciones que están en Mem y WB continúan su ejecución. El resto se matan
	-- Para retornar se debe eligir la siguiente instrucción válida. Para ello tenemos sus direcciones almacenadas en:
	-- PC_exception_EX y PC_exception_ID, y sus bits de validez en valid_I_EX y valid_I_ID
	-- Si no hay válidas se elige el valor del PC.
	-- IMPORTANTE: Si la instrucción en la etapa EX es una RTE no debe elegirse, ya que es una instrucción que ya se ha ejecutado por completo (el retorno se hace en ID), y que ha
	-- ha perdido la información que necesita. Es decir, su LR, porque si ha saltado otra excepción lo habrá borrado.
	-- Para evitar corromper la ejecución añadimos la comprobación RTE_EX='0'
	Return_I	<= 	PC_exception_EX when ((valid_I_EX = '1')AND(RTE_EX = '0')) else 	
					PC_exception_ID when (valid_I_ID = '1') else
					PC_out;		
	------------------------------------------------------------------------------------	
	-- Exception_LR: almacena la dirección a la que hay que retornar tras una excepción	 
	-- Vamos a guardar la dirección seleccionada en el MUX de arriba
	Exception_LR: reg generic map (size => 32)
			port map (	Din => Return_I, clk => clk, reset => reset, load => Exception_accepted_internal, Dout => Exception_LR_output);
			
end Behavioral;
