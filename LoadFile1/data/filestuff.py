#!/usr/bin/python3
f2 = open("newCaptures.txt", "w")
f = open("captures.txt", "r") 
for string in f:
    if "Internet Protocol Version 4, Src:" in string:
        f2.write(string)


