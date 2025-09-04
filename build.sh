#!/bin/sh

nasm -f elf64 -g -F dwarf src.asm && ld src.o -o ping_test.py && rm src.o

