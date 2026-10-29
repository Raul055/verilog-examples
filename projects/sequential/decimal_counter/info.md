# Decimal Counter

## Description
Counts all the way up to 9999 and writes it on the 7-segment display. It refreshes every second.


## I/O Ports
| I/O | Port | Description |
| ----------- | ----------- | ----------- | 
| *Parameter* | **FINAL_VALUE_1s** | Maximum clock count (**default value**: 99_999_999) |
| *Parameter* | **FINAL_VALUE_1khz** | Maximum count for 1kHz (**default value**: 99_999) |
| *Input* | **clk** | Clock signal |
| *Input* | **reset** | Reset signal |
| *Input* | **enable** | Enable signal |
| *Output* | **an[3:0]** | 4-bit anode vector for 7-segment display |
| *Output* | **seg[7:0]** | 7-bit signal display value |

## Block Diagram
![block_diagram](../../../doc/img/decimal_counter.png)