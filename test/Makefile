# normal simulation
ifneq ($(GATES),yes)

all:
	$(MAKE) -C test_top
	$(MAKE) -C test_bit_sampler
	$(MAKE) -C test_decoder

else
# Gate-level simulation

all:
	$(MAKE) -C test_top

endif

clean:
	$(MAKE) -C test_top clean
	$(MAKE) -C test_bit_sampler clean
	$(MAKE) -C test_decoder clean
