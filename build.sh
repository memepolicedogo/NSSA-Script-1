#!/bin/sh

nasm -f elf64 -g -F dwarf src.asm && ld src.o -o script && rm src.o

