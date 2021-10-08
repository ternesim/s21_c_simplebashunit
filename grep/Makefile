CC = gcc
CFLAGS = -Wall -Wextra -Werror -std=c11
DEBUG_FLAGS = -g
NAME=grep
EXECUTABLE = s21_$(NAME)
SRC = s21_$(NAME).c
OBJ = $(SRC:.c=.o)
BUILD_DIR = build
TEST_DIR = test

.PHONY: all clean test build_dir

all: clean $(EXECUTABLE) test

$(EXECUTABLE): $(OBJ)
	$(CC) $(CFLAGS) $(BUILD_DIR)/$^ -o $(BUILD_DIR)/$@

$(OBJ): $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $(BUILD_DIR)/$@

test: $(EXECUTABLE)
	cd $(TEST_DIR) && mkdir -p log \
	&& ./test_func_$(NAME).sh ../$(BUILD_DIR) > log/test_log.txt 2>/dev/null \
  && ./valgrind_two_flags.sh ../$(BUILD_DIR) > log/test_leak_log.txt 2>/dev/null

clean:
	rm -rf *.o *_log.txt $(TEST_DIR)/log $(BUILD_DIR) 

rebuild: clean $(EXECUTABLE)