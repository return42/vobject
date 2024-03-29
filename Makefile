# -*- coding: utf-8; mode: makefile-gmake -*-

test:
	.venv/bin/python tests.py

clean:
	rm -rf .venv

# HINT:
# - black is not supported in py2!
# - option --skip-string-normalization protects (among other things),
#   against deleting the unicode prefix in Python 2

black: venv
	.venv/bin/python -m pip install --upgrade black
	- .venv/bin/python -m black --skip-string-normalization --check --diff .
	@echo "\n"
	@echo "WARNING:"
	@echo "  Not all modifications from black are compatible to Python v2.x !!!"
	@echo "  Don't merge patches of Python-2 unicode like: u'lorem ..' --> 'lorem ..'"
	@echo "\n"

venv: clean
	- asdf local python system
	python --version
	python -m venv .venv
	.venv/bin/python -m pip install --upgrade pip setuptools wheel
	.venv/bin/pip install -r requirements-dev.txt

venv2.7: clean
	- asdf local python 2.7.18
	python --version
	python -m pip install virtualenv
	python -m virtualenv .venv
	.venv/bin/python -m pip install --upgrade pip setuptools wheel
	.venv/bin/pip install -r requirements-dev.txt


.PHONY: test clean venv venv2.7
