VERBOSE ?= @
export MYPYPATH = $(PWD)/stubs

python-packages := language tests setup.py

.PHONY: check check_black check_isort check_flake8 check_pylint check_mypy format \
	test test_python clean

check: check_black check_isort check_flake8 check_pylint check_mypy

check_black:
	black --check --diff --line-length 100 $(python-packages)

check_isort:
	isort --check --diff $(python-packages)

check_flake8:
	flake8 $(python-packages)

check_pylint:
	pylint $(python-packages)

check_mypy:
	mypy --pretty $(python-packages)

format:
	black -l 100 $(python-packages)
	isort $(python-packages)

test: check test_python_coverage

test_python:
	python3 -m pytest -n$(shell nproc)  -vv --ignore=tests/data tests

test_python_coverage:
	python3 -m pytest -n$(shell nproc) -vv --cov=librflxlang --cov-branch --cov-fail-under=71 --cov-report=term-missing:skip-covered --ignore=tests/data tests

install_parser:
	pip3 install .[Devel]

clean:
	rm -rf .mypy_cache .pytest_cache .egg
