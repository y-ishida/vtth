
#valac = /usr/local/bin/valac-0.22
valac = $(HOME)/vala-0.24.0/bin/valac-0.24

bad:
	$(valac) -H foo.h -h internal-foo.h --internal-vapi=foo.vapi -c test.vala

good:
	$(valac) -H foo.h -h internal-bar.h --internal-vapi=foo.vapi -c test.vala

clean:
	rm -f *.[choa] *.vapi
	rm -rf doc

doc:
	valadoc -o doc vttf.vala

