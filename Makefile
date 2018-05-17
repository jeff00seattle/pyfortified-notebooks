#   Makefile
#

PYTHON3 := $(shell which python3.6)
PYTHON3_VERSION := $(shell $(python3.6) --version)

PYFLAKES_ALL_FILES := $(shell find -type f  -name '*.py' ! '(' -name '__init__.py' ')')

REQ_FILE := requirements.txt
TOOLS_REQ_FILE := requirements-tools.txt

check-env:
ifndef QUANDL_WIKI_API_KEY
	$(error QUANDL_WIKI_API_KEY is undefined)
endif

clean:
	@echo "======================================================"
	@echo clean
	@echo "======================================================"
	@rm -fR __pycache__
	@rm -fR *.pyc
	@rm -fR tmp
	@rm -fR *.zip

install-memcached:
	@echo "======================================================"
	@echo install-memcached
	@echo "======================================================"
	brew update
	brew install memcached

upgrade-memcached:
	@echo "======================================================"
	@echo upgrade-memcached
	@echo "======================================================"
	@brew upgrade memcached

flush-memcached:
	@echo "======================================================"
	@echo flush-memcached
	@echo "======================================================"
	@echo 'flush_all' | nc localhost 11211

install-pip:
	@echo "======================================================"
	@echo install-pip
	@echo "======================================================"
	$(PYTHON3) tools/get-pip.py
	$(PYTHON3) -m pip install --upgrade pip

install-freeze:
	@echo "======================================================"
	@echo install-freeze
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pip
	$(PYTHON3) -m pip freeze

install-requirements: $(REQ_FILE)
	@echo "======================================================"
	@echo requirements
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pip
	$(PYTHON3) -m pip install --upgrade -r $(REQ_FILE)

install-tools-requirements: $(TOOLS_REQ_FILE)
	@echo "======================================================"
	@echo tools-requirements
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade -r $(TOOLS_REQ_FILE)

pyflakes: install-tools-requirements
	@echo "======================================================"
	@echo pyflakes
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pyflakes
	$(PYTHON3) -m pyflakes $(PYFLAKES_ALL_FILES)

list:
	cat Makefile | grep "^[a-z]" | awk '{print $$1}' | sed "s/://g" | sort
