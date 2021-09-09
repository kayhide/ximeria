test:
	false; while [[ $$? != 0 ]]; do find src test -type f | entr -cdr test/main; done
.PHONY: test
	
install:
	nix-env -f ./. -i ximeria
.PHONY: install
