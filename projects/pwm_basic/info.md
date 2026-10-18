# Basic PWM

## Description
Basic implementation of N-bit pulse width modulation (PWM).


## I/O Ports
| I/O | Port | Description |
| ----------- | ----------- | ----------- | 
| *Parameter* | **resolution_bits** | Resolution bits for PWM (**default value**: 8)
| *Input* | **clk** | Clock signal |
| *Input* | **reset** | Reset signal |
| *Input* | **duty_cycle[resolution_bits-1:0]** | $(resolution\_bits)$-bit signal for PWM duty cycle |
| *Output* | **pwm_out** | PWM signal |

## Block Diagram
![block_diagram](../../doc/img/pwm%20basic.png)