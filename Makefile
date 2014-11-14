all: compile

watch-compile:
	coffee -cwo compiled src/*.coffee asteroids/*.coffee

compile:
	coffee -co compiled src/*.coffee asteroids/*.coffee
