vlib work
vmap work

vcom Multiplicador32Bit.vhd
vcom Multiplicador32Bit_tb.vhd

vsim mult32_tb

add wave /mult32_tb/sclk
add wave /mult32_tb/sstart
add wave /mult32_tb/mtplcnd
add wave /mult32_tb/mtplcdr
add wave /mult32_tb/res
add wave /mult32_tb/sdone

force -freeze sim:/mult32_tb/sclk 1 0, 0 {25 ps} -r 50
force -freeze sim:/mult32_tb/sstart 0 0
force -freeze sim:/mult32_tb/mtplcnd 01000000000000000000000000000000 0
force -freeze sim:/mult32_tb/mtplcdr 00001111000011110000111100001111 0

force -freeze sim:/mult32_tb/sstart 1 100
force -freeze sim:/mult32_tb/sstart 0 200

view wave
run 3 ns
