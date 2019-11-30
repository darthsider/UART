# UART

UART design implemented in SystemVerilog. Original code was verified using UVM. Modifications have been made to parameterize the design, remove redundant code and prettify the source. It is being verified using open-source SymbiYosys formal tool.

## Design Overview

Parameter Name | Description
---------------|-------------
clk_freq       | Clock frequency in Hertz
baud_rate      | Baud Rate
data_bits      | Number of data bits (Range:5-9)
parity_type    | 0 = None, 1 = Odd, 2 = Even
stop_bits      | Number of stop bits (Range:1-2)

IO Name | Direction | Description
--------|-----------|------------
rx_data_vld | output | Indicates data packet received
rx_data_out | output | Value of data bits in received packet
rx_parity_err | output | Indicates parity error status for received packet
rx | input | Receiver port
tx | output | Transmitter port
tx_active | output | Indicates if transmission is active
tx_data_in | input | Value of data bits for packet to be transmitted
tx_data_vld | input | Indicates data needs to be transmitted
rst | input | Active high synchronous reset
clk | input | Clock


## Prerequisites

For formal verification using [uart.sby](https://github.com/R-Bose/UART/blob/master/FV/uart.sby), install SymbiYosys and related applications first. See [this](https://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing) for complete set of instructions.

- [ ] Instructions to run UVM setup


## Running Formal Setup

```
cd FV
sby -f uart.sby
```


## Authors

List of [contributors](https://github.com/R-Bose/UART/graphs/contributors) who participated in this project.


## License

Files from original project retain their copyright notice as-is.

New files created after forking have been licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html)
