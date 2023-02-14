## ========================================
## Commands for building and testing OMF website deployment
## ========================================

# Settings
MAKEFILES=Makefile $(wildcard *.mk)
UID=$(shell id -u)
GID=$(shell id -g)

# Controls
.PHONY : commands clean stop serve
.NOTPARALLEL:
all : commands

## commands         : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILES} | sed -e 's/## //g'

## build            : build files but do not run a server.
build : 
	docker compose build --pull

## serve            : start and run a local server.
serve : build
	docker compose up -d
	@echo "\nhot-reloading site up at http://localhost:1313, \"make stop\" to stop the server.\n"

## shell            : open a hugo shell
shell : build
	docker compose run --rm --user="${UID}:${GID}" hugo shell

## stop             : stop the docker server and clean up
stop :
	docker compose down -v

## clean            : clean up junk files.
clean :
	@rm -rf ./resources/_gen
	@find . -name .DS_Store -print -exec rm {} \;
	@find . -name '*~' -print -exec rm {} \;
