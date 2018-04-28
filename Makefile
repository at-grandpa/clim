#SPEC_FILES := $(shell find spec -name '*_spec.cr' -print)
SPEC_FILES := spec/clim/dsl_spec/option_type_spec.cr

spec: $(SPEC_FILES)

$(SPEC_FILES):
	crystal spec $@

.PHONY: spec $(SPEC_FILES)