library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
------------------------------------------------------------------------------------
--
--
entity DSP_Suite_Math_32Bits is
    Port (         tx_female : out std_logic;
                   rx_female : in  std_logic;
                   leds : out std_logic_vector(7 downto 0);
		          signal_reset : in  std_logic;
                         clk : in  std_logic;
				-- Signaux externes
				-- Etat actuel
			  state : in STD_LOGIC_VECTOR (2 downto 0);
			  -- Sortie Réglage Alarme
			  reglage_heure_alarme : in  STD_LOGIC_VECTOR (4 downto 0);
           reglage_minute_alarme : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Heure actuelle
			  heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  seconde : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Temps écoulé
			  chrono_heure : in  STD_LOGIC_VECTOR (4 downto 0);
           chrono_minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  chrono_seconde : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Alarme On / Off
			  alarme_active : in STD_LOGIC);	
    end DSP_Suite_Math_32Bits;


--
------------------------------------------------------------------------------------
--
-- Start of test architecture
--
architecture Behavioral of DSP_Suite_Math_32Bits is
--
------------------------------------------------------------------------------------

--
-- declaration of KCPSM3
--
  component kcpsm3 
    Port (      address : out std_logic_vector(9 downto 0);
            instruction : in std_logic_vector(17 downto 0);
                port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
            read_strobe : out std_logic;
                in_port : in std_logic_vector(7 downto 0);
              interrupt : in std_logic;
          interrupt_ack : out std_logic;
                  reset : in std_logic;
                    clk : in std_logic);
    end component;
--
-- declaration of program ROM
--
  component prog_rom
    Port (      address : in std_logic_vector(9 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                  reset : out std_logic;                       --JTAG Loader version
                    clk : in std_logic);
    end component;
--
-- declaration of UART transmitter with integral 16 byte FIFO buffer
-- Note this is a modified version of the standard 'uart_tx' in which
-- the 'data_present' signal has also been brought out to better support 
-- the XON/XOFF flow control.
--  
  component uart_tx_plus
    Port (              data_in : in std_logic_vector(7 downto 0);
                   write_buffer : in std_logic;
                   reset_buffer : in std_logic;
                   en_16_x_baud : in std_logic;
                     serial_out : out std_logic;
            buffer_data_present : out std_logic;
                    buffer_full : out std_logic;
               buffer_half_full : out std_logic;
                            clk : in std_logic);
    end component;
--
-- declaration of UART Receiver with integral 16 byte FIFO buffer
--
  component uart_rx
    Port (            serial_in : in std_logic;
                       data_out : out std_logic_vector(7 downto 0);
                    read_buffer : in std_logic;
                   reset_buffer : in std_logic;
                   en_16_x_baud : in std_logic;
            buffer_data_present : out std_logic;
                    buffer_full : out std_logic;
               buffer_half_full : out std_logic;
                            clk : in std_logic);
  end component;


component affichage_liaison_serie is
    Port ( -- Etat actuel
			  state : in STD_LOGIC_VECTOR (2 downto 0);
			  -- Sortie Réglage Alarme
			  reglage_heure_alarme : in  STD_LOGIC_VECTOR (4 downto 0);
           reglage_minute_alarme : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Heure actuelle
			  heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  seconde : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Temps écoulé
			  chrono_heure : in  STD_LOGIC_VECTOR (4 downto 0);
           chrono_minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  chrono_seconde : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Alarme On / Off
			  alarme_active : in STD_LOGIC;
			  
           CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
		START : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--
------------------------------------------------------------------------------------
--
-- Signals used to connect KCPSM3 to program ROM and I/O logic
--
signal  address         : std_logic_vector(9 downto 0);
signal  instruction     : std_logic_vector(17 downto 0);
signal  port_id         : std_logic_vector(7 downto 0);
signal  out_port        : std_logic_vector(7 downto 0);
signal  in_port         : std_logic_vector(7 downto 0);
signal  write_strobe    : std_logic;
signal  read_strobe     : std_logic;
signal  interrupt       : std_logic :='0';
signal  interrupt_ack   : std_logic;
--
-- Signals for connection of peripherals
--
signal      status_port : std_logic_vector(7 downto 0);
--
--
-- Signals for UART connections
--
signal       baud_count : integer range 0 to 26 :=0;
signal     en_16_x_baud : std_logic;
signal    write_to_uart : std_logic;
signal  tx_data_present : std_logic;
signal          tx_full : std_logic;
signal     tx_half_full : std_logic;
signal   read_from_uart : std_logic;
signal          rx_data : std_logic_vector(7 downto 0);
signal  rx_data_present : std_logic;
signal          rx_full : std_logic;
signal     rx_half_full : std_logic;
--
--
-- Signals used to generate interrupt 
--
signal previous_rx_half_full : std_logic;
signal    rx_half_full_event : std_logic;
--
--

--
--
-- Signaux relatifs à l'intégration de la FIFO
--
signal  calculateur_input  : std_logic_vector(31 downto 0);
signal  calculateur_output : std_logic_vector(31 downto 0);
signal  calculateur_raz    : std_logic;
signal  calculateur_start  : std_logic;

--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Start of circuit description
--
begin
  --
  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- Disable unused components  
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  -- Although the LCD display only uses pins shared with the StrataFLASH upper data bits [15:8] the
  -- following signals ensure that no possible conflict can occur when experimenting with the 
  -- StrataFLASH memory beyond the design currently presented.
  --
  --
  -- The LSB of the data bus to and from the StrataFLASH device (D0) is connected to many components.
  -- This occurs because the board provides multiple ways to configure the Spartan-3E device and   
  -- consequently all these use the configuration DIN pin. Since one of these configuration options 
  -- is SPI memory, the board also implements an SPI bus to which further devices are connected.
  -- The following signals ensure that additional connections to 'D0' can not cause any conflict with 
  -- access to the StrataFLASH device.
  --
  -- platformflash_oe <= '0';    --Disable (reset) Platform FLASH device used in master serial configuration.
  -- spi_rom_cs <= '1';          --Disable SPI FLASH device used in SPI configuration.
  -- spi_adc_conv <= '0';        --Prevent SPI based A/D converter from generating sample data.
  -- spi_dac_cs <= '1';          --Disable SPI based D/A converter interface.
  --
  --
  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- Set 8-bit mode of operation for StrataFLASH memory  
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  -- The StrataFLASH memory can be used in 8-bit or 16-bit modes. Since PicoBlaze is an 8-bit 
  -- processor and the configuration from parallel flash is conducted using an 8-bit interface, 
  -- this design forces the 8-bit data mode.
  --
  -- As a result, the 128Mbit memory is organised as 16,777,216 bytes accessed using a 24-bit address.
  --
  -- strataflash_byte <= '0';
  --
  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- Bidirectional data interface for StrataFLASH memory  
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  -- To read the StrataFLASH memory the output enable (OE) signal must be driven Low on the memory and 
  -- the pins on the Spartan-3E must become inputs (i.e. the output buffers must be high impedance).
  --
  --
  -- strataflash_oe <= not(strataflash_read);  --active Low output enable
  --
  -- strataflash_d <= write_data when (strataflash_read='0') else "ZZZZZZZZ";
  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- KCPSM3 and the program memory 
  ----------------------------------------------------------------------------------------------------------------------------------
  --

  processor: kcpsm3
    port map(      address => address,
               instruction => instruction,
                   port_id => port_id,
              write_strobe => write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     reset => signal_reset,
                       clk => clk);
 
  program_rom: prog_rom
    port map(      address => address,
               instruction => instruction,
                     --reset => signal_reset,
                       clk => clk);



  Afficheur : affichage_liaison_serie
    Port Map(
			  state => state,
			  reglage_heure_alarme => reglage_heure_alarme,
           reglage_minute_alarme => reglage_minute_alarme,
			  heure => heure,
           minute => minute,
			  seconde => seconde,
			  chrono_heure => chrono_heure,
           chrono_minute => chrono_minute,
			  chrono_seconde => chrono_seconde,
			  alarme_active => alarme_active,
           CLOCK    => clk,
			  RESET    => calculateur_raz,
		START => calculateur_start,
           Y		  => calculateur_output
	 );


  
  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- Interrupt 
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  --
  -- Interrupt is used to detect when the UART receiver FIFO reaches half full and this is 
  -- then used to send XON and XOFF flow control characters back to the PC.
  --
  -- If 'rx_half_full' goes High, an interrupt is generated and the subsequent ISR will transmit
  -- an XOFF character to stop the flow of new characters from the PC and allow the FIFO to start to empty.
  --
  -- If 'rx_half_full' goes Low, an interrupt is generated and the subsequent ISR will transmit
  -- an XON character which will allow the PC to send new characters and allow the FIFO to start to fill.
  --

  interrupt_control: process(clk)
  begin
    if clk'event and clk='1' then

      -- detect change in state of the 'rx_half_full' flag.
      previous_rx_half_full <= rx_half_full; 
      rx_half_full_event    <= previous_rx_half_full xor rx_half_full; 

      -- processor interrupt waits for an acknowledgement
      if interrupt_ack='1' then
         interrupt <= '0';
        elsif rx_half_full_event='1' then
         interrupt <= '1';
        else
         interrupt <= interrupt;
      end if;

    end if; 
  end process interrupt_control;

  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- KCPSM3 input ports 
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  --
  -- UART FIFO status signals to form a bus
  -- Also the status signal (STS) from the StrataFlash memory

  status_port <= "00" & rx_full & rx_half_full & rx_data_present & tx_full & tx_half_full & tx_data_present;

  --
  -- The inputs connect via a pipelined multiplexer
  --

  input_ports: process(clk)
  begin
    if clk'event and clk='1' then

		-- On valide l'écriture ou non dans la fifo de sortie
		-- fifo_in_read <= port_id(2) and not port_id(1) and port_id(0) and read_strobe;

      case port_id(7 downto 0) is

        
        -- read status signals at address 00 hex
        when "00000000" =>    in_port <= status_port;

        -- read UART receive data at address 01 hex
        when "00000001" =>    in_port <= rx_data;

        -- ON VA LIRE L'ETAT DE LA SORTIE DU SOMMATEUR (PARTIE 1)
        when "00000100" =>    in_port <= calculateur_output(7 downto 0);

        -- ON VA LIRE L'ETAT DE LA SORTIE DU SOMMATEUR (PARTIE 2)
        when "00000101" =>    in_port <= calculateur_output(15 downto 8);

        -- ON VA LIRE L'ETAT DE LA SORTIE DU SOMMATEUR (PARTIE 3)
        when "00000110" =>    in_port <= calculateur_output(23 downto 16);

        -- ON VA LIRE L'ETAT DE LA SORTIE DU SOMMATEUR (PARTIE 4)
        when "00000111" =>    in_port <= calculateur_output(31 downto 24);

        -- Don't care used for all other addresses to ensure minimum logic implementation
        when others =>    in_port <= "XXXXXXXX";

      end case;

      -- Form read strobe for UART receiver FIFO buffer at address 01 hex.
      -- The fact that the read strobe will occur after the actual data is read by 
      -- the KCPSM3 is acceptable because it is really means 'I have read you'!
 
      if (read_strobe='1' and port_id="00000001") then 
        read_from_uart <= '1';
       else 
        read_from_uart <= '0';
      end if;

 
    end if;
  end process input_ports;

	
  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- KCPSM3 output ports 
  ----------------------------------------------------------------------------------------------------------------------------------
  --

  -- adding the output registers to the processor
  
  -- leds    <= fifo_in_data;
  
  output_ports: process(clk)
  begin

    if clk'event and clk='1' then

		-- On valide l'écriture ou non dans la fifo de sortie
		-- fifo_out_write <= port_id(4) and write_strobe;

      if write_strobe='1' then

        -- The 24-bit address to the StrataFLASH memory requires 3 ports.

        
        --if port_id = "10000000" then
        --  fifo_out_data <= out_port;
        --end if;

        -- Address [15:8] at port 40 hex 
        if port_id = "01000000" then
          leds(7 downto 0) <= out_port;
        end if;

        -- Ecriture des entrées du sommateur (Partie 1)
        if port_id = "00100000" then
			calculateur_input(7 downto 0) <= out_port;
        end if;

        -- Ecriture des entrées du sommateur (Partie 2)
        if port_id = "00100001" then
			calculateur_input(15 downto 8) <= out_port;
        end if;

        -- Ecriture des entrées du sommateur (Partie 3)
        if port_id = "00100010" then
			calculateur_input(23 downto 16) <= out_port;
        end if;

        -- Ecriture des entrées du sommateur (Partie 4)
        if port_id = "00100011" then
			calculateur_input(31 downto 24) <= out_port;
        end if;


      end if;

		-- On gere la commande de start du sommateur
		-- lorsque accede à l'adresse "00100100"
      if (write_strobe='1' and port_id="00100100") then 
        calculateur_start <= '1';
       else 
        calculateur_start <= '0';
      end if;

		-- On gere la commande de raz du sommateur
		-- lorsque accede à l'adresse "00100101"
      if (write_strobe='1' and port_id="00100101") then 
        calculateur_raz <= '1';
       else 
        calculateur_raz <= '0';
      end if;
		-- Fin de la gestion de la fifo

    end if; 
  end process output_ports;

  --
  -- write to UART transmitter FIFO buffer at address 04 hex.
  -- This is a combinatorial decode because the FIFO is the 'port register'.
  --

  write_to_uart <= '1' when (write_strobe='1' and port_id(7)='1') else '0';


  --
  ----------------------------------------------------------------------------------------------------------------------------------
  -- UART  
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  -- Connect the 8-bit, 1 stop-bit, no parity transmit and receive macros.
  -- Each contains an embedded 16-byte FIFO buffer.
  --

  transmit: uart_tx_plus 
  port map (              data_in => out_port, 
                     write_buffer => write_to_uart,
                     reset_buffer => '0',
                     en_16_x_baud => en_16_x_baud,
                       serial_out => tx_female,
              buffer_data_present => tx_data_present,
                      buffer_full => tx_full,
                 buffer_half_full => tx_half_full,
                              clk => clk );

  receive: uart_rx
  port map (            serial_in => rx_female,
                         data_out => rx_data,
                      read_buffer => read_from_uart,
                     reset_buffer => '0',
                     en_16_x_baud => en_16_x_baud,
              buffer_data_present => rx_data_present,
                      buffer_full => rx_full,
                 buffer_half_full => rx_half_full,
                              clk => clk );  
  
  --
  -- Set baud rate to 115200 for the UART communications
  -- Requires en_16_x_baud to be 1843200Hz which is a single cycle pulse every 27 cycles at 50MHz 
  --

  baud_timer: process(clk)
  begin
    if clk'event and clk='1' then
      if baud_count=26 then
         baud_count <= 0;
         en_16_x_baud <= '1';
       else
         baud_count <= baud_count + 1;
         en_16_x_baud <= '0';
      end if;
    end if;
  end process baud_timer;

  --
  ----------------------------------------------------------------------------------------------------------------------------------

end Behavioral;

------------------------------------------------------------------------------------------------------------------------------------
--
-- END OF FILE parallel_flash_memory_uart_programmer.vhd
--
------------------------------------------------------------------------------------------------------------------------------------

