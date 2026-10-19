# Decimal Counter

## Description
Counts all the way up to 9999 and writes it on the 7-segment display. It refreshes every second.


## I/O Ports
| I/O | Port | Description |
| ----------- | ----------- | ----------- | 
| *Parameter* | **MAX_CLK_COUNT** | Maximum clock count (**default value**: 50_000_000)
| *Input* | **clk** | Clock signal |
| *Input* | **reset** | Reset signal |
| *Output* | **an[3:0]** | 4-bit anode vector for 7-segment display |
| *Output* | **seg[7:0]** | 7-bit signal display value |

## Block Diagram
![block_diagram](../../../doc/img/decimal_counter.png)