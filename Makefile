
CC = g++
STD = c++23

#ARCH = arm64
#ARCH = x86_64

CFLAGS_TEST = -std=$(STD) -Wall -Wextra -Wpedantic -l wiringPi # -Werror -Wpedantic -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-unused-private-field -l wiringPi
CFLAGS_PROD = -std=$(STD) -flto -Wall -Wextra -O3 -l wiringPi -march=aarch64-linux-gnu -static
# CFLAGS_PROD = -arch $(ARCH) -std=$(STD) -Wall -Wextra -O3

DIR_SRC = ./src/
DIR_TARGET = ./target/

MAIN = main.cpp
TARGET = main.out

THIS_FILE := $(lastword $(MAKEFILE_LIST))
SRC = $(shell find $(DIR_SRC) -type f -name '*.cpp')
# SRC = $(wildcard $(DIR_SRC)*.cpp)

#DATAFILES = $(wildcard $(DIR_SRC)*.txt) $(wildcard $(DIR_SRC)*.csv)

setup:
	@echo "creating target directory"
	@if [ ! -d $(DIR_TARGET) ]; then mkdir $(DIR_TARGET); fi

test:
	@$(MAKE) -f $(THIS_FILE) setup
	@echo "$(CC) $(SRC) -o $(DIR_TARGET)$(TARGET) $(CFLAGS_TEST)"
	@$(CC) $(SRC) -o $(DIR_TARGET)$(TARGET) $(CFLAGS_TEST)
	@echo "Build complete."


build: 
	@$(MAKE) -f $(THIS_FILE) setup
	@echo "Building..."
	@echo "$(CC) $(CFLAGS_PROD) $(SRC) -o $(DIR_TARGET)$(TARGET)"
	@$(CC) $(SRC) -o $(DIR_TARGET)$(TARGET) $(CFLAGS_TEST)
	@echo "Build complete."
	@for file in *.out *.sh; do if [ -e "$file" ]; then chmod +x "$file"; fi; done

run: 
	@$(MAKE) -f $(THIS_FILE) setup
	@if [ ! -d $(DIR_TARGET)/$(TARGET) ]; then $(MAKE) -f $(THIS_FILE) test ; fi
	@echo "Running..."
	@cd $(DIR_TARGET) && ./$(TARGET) ./config.env

debug:
	@if [ ! -d $(DIR_TARGET)/$(TARGET) ]; then $(MAKE) -f $(THIS_FILE) test ; fi
	@echo "Running in debug mode..."
	@cd $(DIR_TARGET) && AP_DEBUG=1 ./$(TARGET)

clean:
	@echo "Cleaning..."
	@rm -rf $(DIR_TARGET)
	@$(MAKE) -f $(THIS_FILE) setup

VERSION_FILE = VERSION

bump_major:
	@echo "Bumping major version..."
	@$(eval VERSION=$(shell cat $(VERSION_FILE)))
	@$(eval MAJOR=$(shell echo $(VERSION) | cut -d. -f1))
	@$(eval MINOR=$(shell echo $(VERSION) | cut -d. -f2))
	@$(eval NEW_MAJOR=$(shell echo $$(($(MAJOR) + 1))))
	@echo "$(NEW_MAJOR).0" > $(VERSION_FILE)
	@echo "Version bumped to $(NEW_MAJOR).0"

bump_minor:
	@echo "Bumping minor version..."
	@$(eval VERSION=$(shell cat $(VERSION_FILE)))
	@$(eval MAJOR=$(shell echo $(VERSION) | cut -d. -f1))
	@$(eval MINOR=$(shell echo $(VERSION) | cut -d. -f2))
	@$(eval NEW_MINOR=$(shell echo $$(($(MINOR) + 1))))
	@echo "$(MAJOR).$(NEW_MINOR)" > $(VERSION_FILE)
	@echo "Version bumped to $(MAJOR).$(NEW_MINOR)"

bump_patch:
	@echo "Bumping patch version..."
	@$(eval VERSION=$(shell cat $(VERSION_FILE)))
	@$(eval MAJOR=$(shell echo $(VERSION) | cut -d. -f1))
	@$(eval MINOR=$(shell echo $(VERSION) | cut -d. -f2))
	@$(eval PATCH=$(shell echo $(VERSION) | cut -d. -f3))
	@$(eval NEW_PATCH=$(shell echo $$(($(PATCH) + 1))))
	@echo "$(MAJOR).$(MINOR).$(NEW_PATCH)" > $(VERSION_FILE)
	@echo "Version bumped to $(MAJOR).$(MINOR).$(NEW_PATCH)"