
#valac = /usr/local/bin/valac-0.22
valac = $(HOME)/vala-0.24.0/bin/valac-0.24

all:
	$(valac) sample.vala vtth.vala

check: sample
	./sample

clean:
	rm -f *.[choa] *.vapi
	rm -rf doc

doc:
	valadoc -o doc vttf.vala

