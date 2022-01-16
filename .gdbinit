define nb
	shell nix build .#debug-test -L
	file result/bin/tests
end
define nbr
	nb
	run
end
