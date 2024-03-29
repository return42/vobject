# -*- coding: utf-8; mode: makefile-gmake -*-

test:
	.venv/bin/python tests.py

clean:
	rm -rf .venv

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
