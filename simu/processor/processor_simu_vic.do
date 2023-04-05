vlib work

vcom -2008 ../../src/sign_extender.vhd
vcom -2008 ../../src/reg.vhd
vcom -2008 ../../src/mux2v1.vhd
vcom -2008 ../../src/alu.vhd
vcom -2008 ../../src/instruction_memory_irq.vhd
vcom -2008 ../../src/memory.vhd
vcom -2008 ../../src/psr.vhd
vcom -2008 ../../src/reg_en.vhd
vcom -2008 ../../src/registers.vhd
vcom -2008 ../../src/instruction_unit.vhd
vcom -2008 ../../src/instruction_decoder.vhd
vcom -2008 ../../src/processing_unit.vhd
vcom -2008 ../../src/vectored_interrupt_controller.vhd
vcom -2008 ../../src/processor.vhd
vcom -2008 processor_vic_tb.vhd

vsim processor_vic_tb(Bench)

view signals
add wave *
add wave processor/instruction_decoder/current_instruction
add wave -radix unsigned processor/instruction_unit/IRQ
add wave -radix unsigned processor/instruction_unit/PC
add wave -radix unsigned processor/instruction_unit/LR
add wave processor/vectored_interrupt_controller/IRQ_SERV
add wave processor/vectored_interrupt_controller/IRQ0_memo
add wave processor/vectored_interrupt_controller/IRQ1_memo

radix signal Display hexadecimal

run -all
wave zoom full