TOP_TEST = test_top

SUBMODULE_TESTS = \
    test_bit_sampler \
    test_decoder \
    test_digit \
    test_digits \
    test_shift_reg \
    test_time_date_decoder

ALL_TESTS = $(TOP_TEST) $(SUBMODULE_TESTS)

ifneq ($(GATES),yes)
    # normal simulation
    TESTS = $(ALL_TESTS)
else
    # gate level simulation
    TESTS = $(TOP_TEST)
endif

.PHONY: all $(TESTS)

all: $(TESTS)

$(TESTS):
	$(MAKE) -C $@

clean:
	for dir in $(ALL_TESTS); do \
		$(MAKE) -C $$dir clean; \
	done
