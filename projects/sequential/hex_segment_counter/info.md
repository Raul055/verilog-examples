# Hexadecimal Segment Counter

## Description
Counts all the way up from 0 to F hexadecimal value and then down from F to 0. It refreshes every second.

## I/O Ports
| I/O | Port | Description |
| ----------- | ----------- | ----------- | 
| *Parameter* | **MAX_COUNT** | Maximum clock count (**default value**: 100_000_000)
| *Input* | **clk** | Clock signal |
| *Input* | **reset** | Reset signal |
| *Output* | **an[3:0]** | 4-bit anode vector for 7-segment display |
| *Output* | **seg[7:0]** | 7-bit signal display value |

## Block Diagram
![block_diagram](../../../doc/img/hex_segment_counter.png)