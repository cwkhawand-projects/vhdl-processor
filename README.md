# VHDL ARM7TDMI Processor with Vectored Interrupts and UART Transmission
This repository contains the VHDL implementation of an ARM7TDMI processor that supports vectored interruptions and UART transmission. The ARM7TDMI (Thumb and Debug Extensions, Multiplier, ICEBreaker Implementation) is a 32-bit RISC processor designed by ARM Holdings.

## Table of Contents
- Introduction
- Features
- Getting Started
- Architecture
- License

## Introduction
The ARM7TDMI processor is widely used in various embedded systems, offering a good balance between performance, power consumption, and cost. This VHDL implementation provides a synthesizable model of the ARM7TDMI processor, including vectored interrupt handling and UART transmission capabilities.

## Features
- Simplified implementation of the ARM7TDMI processor in VHDL
- Vectored interrupt handling
- UART transmission module
- Easy-to-use and configurable design

## Getting Started
To get started with this VHDL implementation of the ARM7TDMI processor, follow these steps:

1. Clone this repository to your local machine:

```bash
git clone https://github.com/cwkhawand/vhdl-processor.git
```

2. Open the project in your favorite VHDL development environment (e.g., Xilinx ISE, Intel Quartus Prime).
3.Configure the desired settings for the processor, such as clock frequency, memory size, and UART parameters.
4. Build the project and synthesize the design to obtain the corresponding bitstream.
5. Program the bitstream onto your FPGA development board.
6. Connect peripherals and devices, such as a UART terminal, to the appropriate pins on your FPGA board.
7. Power on the board and start using the ARM7TDMI processor with vectored interrupts and UART transmission!

## Architecture
The VHDL implementation of the ARM7TDMI processor follows the ARM7TDMI specifications and consists of various modules, including:

- ARM Core: Implements the core instruction set of the ARM7TDMI processor.
- Memory Interface: Provides the interface for accessing memory (both data and instruction) and peripherals.
- Vectored Interrupt Controller: Handles vectored interrupts by prioritizing and routing them to the appropriate interrupt service routines.
- UART Module: Implements UART (Universal Asynchronous Receiver/Transmitter) transmission capabilities for serial communication.

The architecture is designed to be modular and easily configurable to meet specific project requirements.

## /!\ Note
Some testbenches might not work because the entities related to them have changed.

## License
This project is licensed under the MPL2.0 License, which allows you to use, modify, and distribute the code freely. See the LICENSE file for more information.
