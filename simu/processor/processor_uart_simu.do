vlib work

vcom -2008 ../../src/sign_extender.vhd
vcom -2008 ../../src/reg.vhd
vcom -2008 ../../src/mux2v1.vhd
vcom -2008 ../../src/alu.vhd
vcom -2008 ../../src/instruction_memory_UART.vhd
vcom -2008 ../../src/fdiv.vhd
vcom -2008 ../../src/reg_uart.vhd
vcom -2008 ../../src/uart_tx.vhd
vcom -2008 ../../src/uart_rx.vhd
vcom -2008 ../../src/uart.vhd
vcom -2008 ../../src/memory.vhd
vcom -2008 ../../src/psr.vhd
vcom -2008 ../../src/reg_en.vhd
vcom -2008 ../../src/registers.vhd
vcom -2008 ../../src/instruction_unit.vhd
vcom -2008 ../../src/instruction_decoder.vhd
vcom -2008 ../../src/processing_unit.vhd
vcom -2008 ../../src/vectored_interrupt_controller.vhd
vcom -2008 ../../src/processor.vhd
vcom -2008 processor_uart_tb.vhd

vsim processor_uart_tb(Bench_receive)

view signals
add wave *
add wave /processor_uart_tb/processor/instruction_decoder/current_instruction 
add wave -radix unsigned /processor_uart_tb/processor/instruction_unit/PC 
add wave /processor_uart_tb/processor/uart/RxIrq 
add wave -radix hexadecimal /processor_uart_tb/processor/uart/RxData 
add wave -radix hexadecimal /processor_uart_tb/processor/processing_unit/registers/Registers 
add wave -radix hexadecimal /processor_uart_tb/processor/processing_unit/memory/Memory 
radix signal Display hexadecimal

run -all
wave zoom full