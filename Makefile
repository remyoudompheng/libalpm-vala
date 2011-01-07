VALAFLAGS = -v -X -I. -X -lalpm --vapidir . --pkg alpm

APIFILES = alpm.vapi alpm-list.vapi

all: test pactree

test: test.vala $(APIFILES)
	valac -o test $(VALAFLAGS) $<

pactree: pactree.vala $(APIFLAGS)
	valac -o pactree $(VALAFLAGS) $<

clean:
	rm -f pactree test
