NUM_OF_JOBS := 1
SPEC_FILES := $(shell find spec -name '*_spec.cr' -print | sort -n)
SPEC_TARGETS := $(shell seq -s " " -f "spec/%g" $(NUM_OF_JOBS))

spec:
	make -j $(SPEC_TARGETS)

format-check:
	crystal tool format --check

.PHONY: spec format-check

spec/%:
	docker run \
		--rm \
		-it \
		-v $(PWD):/workdir \
		-w /workdir \
		crystallang/crystal:latest \
		/bin/sh -c "crystal eval 'array = \"$(SPEC_FILES)\".split(\" \"); puts array.in_groups_of((array.size / ($(NUM_OF_JOBS))).ceil.to_i).map(&.compact)[$* - 1].join(\" \")' | xargs -d \" \" -I{} /bin/sh -c 'echo \"\n\n=========================\n{}\"; crystal spec {}'"
