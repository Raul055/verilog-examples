# OPTIONAL FLAGS, DEFAULTS
DEBUG ?= 0
ENABLE_WARNINGS ?= 0
WARNINGS_AS_ERRORS ?= 0

# INCLUDED DIRECTORIES
MAIN_DIR = c_files
INCLUDE_DIR = include
SOURCE_DIR = src
BUILD_DIR = build

# WARNING ENABLE
ifeq ($(ENABLE_WARNINGS), 1)
CXX_WARNINGS = -Wall -Wextra -Wpedantic
else
CXX_WARNINGS =
endif

# WARNING AS ERROR ENABLE
ifeq ($(WARNINGS_AS_ERRORS), 1)
CXX_WARNINGS += -Werror
endif

CXX_STANDARD = c11
CXX = gcc
CXXFLAGS = $(CXX_WARNINGS) -std=$(CXX_STANDARD)
CPPFLAGS = -I $(MAIN_DIR)/$(INCLUDE_DIR)
LDFLAGS =

ifeq ($(DEBUG), 1)
CXXFLAGS += -g -O0
EXECUTABLE_NAME = debug
else
CXXFLAGS += -O3
EXECUTABLE_NAME = verilog_testbench
endif

CXX_COMPILER_CALL = $(CXX) $(CXXFLAGS) $(CPPFLAGS)

CXX_SOURCES = $(wildcard $(MAIN_DIR)/$(SOURCE_DIR)/*.c)
CXX_OBJECTS = $(patsubst $(MAIN_DIR)/$(SOURCE_DIR)/%.c, $(BUILD_DIR)/%.o, $(CXX_SOURCES))

##############
## TARGETS  ##
##############
all: create build

create:
	@mkdir -p $(BUILD_DIR)

build: $(CXX_OBJECTS)
	$(CXX_COMPILER_CALL) $(CXX_OBJECTS) $(LDFLAGS) -o $(BUILD_DIR)/$(EXECUTABLE_NAME)

execute:
	./$(BUILD_DIR)/$(EXECUTABLE_NAME)

clean:
	rm -f $(BUILD_DIR)/*.o
	rm -f $(BUILD_DIR)/$(EXECUTABLE_NAME)

##############
## PATTERNS ##
##############
# FIXED: Included $(MAIN_DIR) in path matching
$(BUILD_DIR)/%.o: $(MAIN_DIR)/$(SOURCE_DIR)/%.c
	$(CXX_COMPILER_CALL) -c $< -o $@

###########
## PHONY ##
###########
.PHONY: all create build execute clean