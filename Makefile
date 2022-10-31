PHONY:
	reload

reload:
	darwin-rebuild switch --flake .#macbookpro-m1
