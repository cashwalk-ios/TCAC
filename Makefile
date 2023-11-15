generate:
	tuist clean
	tuist fetch
	ls
	tuist generate --no-open
	xed .
