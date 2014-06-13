
sample: sample.vala vtth.vala
	valac sample.vala vtth.vala

check: sample
	./sample

clean:
	rm -f sample
	rm -rf doc

doc:
	valadoc -o doc vttf.vala

