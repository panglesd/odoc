.PHONY : build
build :
	dune build

.PHONY : publish-docs
publish-docs:
	dune build @doc
	dune build @docgen || true
	git checkout gh-pages
	rsync -av _build/default/doc/html/odoc/ .

.PHONY : test
test :
	dune runtest

# Echo is disabled as the benchmarks results are printed on stdout.
# '@bench' exit status is not checked as it's very likely to fail due to
# needing promotion rather than because it really failed.
.PHONY : bench
bench:
	-@dune build @bench
	@dune promote driver-benchmarks.json
	@cat driver-benchmarks.json

.PHONY : coverage
coverage :
	dune build --instrument-with bisect_ppx @test/runtest --no-buffer -j 1 --force || true
	bisect-ppx-report html
	@echo See _coverage/index.html

.PHONY : clean
clean :
	dune clean
	rm -r _coverage
