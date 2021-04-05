NUM_OF_JOBS := 1
SPEC_FILES := $(shell find spec -name '*_spec.cr' -print | sort -n)
SPEC_TARGETS := $(shell seq -s " " -f "spec/%g" $(NUM_OF_JOBS))
SPEC_COMPLETION_FILES := $(shell find spec_completion -name '*_spec.cr' -print | sort -n)

.PHONY: spec
spec:
	make -j $(SPEC_TARGETS) DOCKER_OPTIONS=-it

.PHONY: format-check
format-check:
	docker run \
		--rm \
		$(DOCKER_OPTIONS) \
		-v $(PWD):/workdir \
		-w /workdir \
		crystallang/crystal:latest \
		/bin/sh -c "crystal tool format --check"


spec/%:
	crystal -v
	crystal eval 'array = "$(SPEC_FILES)".split(" "); puts array.map_with_index{|e,i| {index: i, value: e}}.group_by{|e| e[:index] % ($(NUM_OF_JOBS))}[$* - 1].map(&.[](:value)).join("\n")' | xargs -n 1 -I{} /bin/sh -c 'echo "\n\n=========================\n{}"; crystal spec {}'


.PHONY: spec_completion
spec_completion: $(SPEC_COMPLETION_FILES)

.PHONY: $(SPEC_COMPLETION_FILES)
$(SPEC_COMPLETION_FILES):
	crystal -v
	crystal spec $@
