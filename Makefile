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

# HINT: pylint uses the AST (https://docs.python.org/3/library/ast.html) from
# the python interpreter.  To lint a py2 code base a Python 2 interpreter is
# needed.

# pylint in py3.x: all rules are taken from .pylintrc
pylint: venv
	.venv/bin/python -m pylint --output-format=parseable ./vobject/ setup.py tests.py

# pylint in py2.7: addtional to the rules from .pylintrc disable messages which
# are only relevant in python 3
pylint2.7: venv2.7
	.venv/bin/python -m pylint --output-format=parseable \
		--disable=bad-continuation,superfluous-parens,old-style-class \
		./vobject/ setup.py tests.py

venv: clean
	- asdf local python system
	@python --version
	@python -c "import sys; sys.version_info[0] == 3 or (sys.stderr.write('ERROR: python 3 is required!\n'), sys.exit(42))"
	python -m venv .venv
	.venv/bin/python -m pip install --upgrade pip setuptools wheel
	.venv/bin/pip install -r requirements-dev.txt

venv2.7: clean
	- asdf local python 2.7.18
	@python --version
	@python -c "import sys; sys.version_info[0] == 2 or (sys.stderr.write('ERROR: python 2 is required!\n'), sys.exit(42))"
	python -m pip install virtualenv
	python -m virtualenv .venv
	.venv/bin/python -m pip install --upgrade pip setuptools wheel
	.venv/bin/pip install -r requirements-dev.txt


.PHONY: test clean venv venv2.7 black pylint pylint2.7
