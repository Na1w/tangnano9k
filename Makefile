YOSYS ?= yosys
NEXTPNR ?= nextpnr-gowin

all:	test-tangnano4k-prog

clean:	
	rm -rf *.json *.fs *-unpacked.v

.PHONY: all clean 

%-tangnano9k.fs: %-tangnano9k.json
	gowin_pack -d GW1N-9C -o $@ $^

%-tangnano9k.json: %-tangnano9k-synth.json tangnano9k.cst
	$(NEXTPNR) --json $< --write $@ --device GW1NR-LV9QN88PC6/I5 --family GW1N-9C --cst tangnano9k.cst

%-tangnano9k-synth.json: %.v
	$(YOSYS) -q -D LEDS_NR=6 -D OSC_TYPE_OSC -p "read_verilog $^; synth_gowin -json $@"

%-tangnano9k-unpacked.v: %-tangnano9k.fs
	gowin_unpack -d GW1N-9C -o $@ $^

%-tangnano4k-prog: %-tangnano9k.fs
	openFPGALoader -b tangnano9k $^

%-tangnano4k-prog-flash: %-tangnano9k.fs
	openFPGALoader -f -b tangnano9k $^
