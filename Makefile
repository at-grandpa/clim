SPEC_FILES := $(shell find spec -name '*_spec.cr' -print | sort -n)

spec: $(SPEC_FILES)

$(SPEC_FILES):
	crystal spec $@ $(SPEC_OPTS)

.PHONY: spec $(SPEC_FILES)
