onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib fifo_1k_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_1k.udo}

run -all

quit -force
