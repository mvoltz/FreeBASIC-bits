
#pragma once
#include "crt.bi"
#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

dim as byte c

open cons for input as STDIN_FILENO

while c not "q" 
  line input #1,c
wend
