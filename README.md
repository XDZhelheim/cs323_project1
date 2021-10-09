# CS323 Project 1 Report

11812804 董正

11813225 王宇辰

## 1 Introduction

### 1.1 Project Requirements

This project is to implement a parser that accepts a single command line argument (the SPL file path), and outputs the parse tree for a syntactically valid SPL program, or the message reporting all existing lexical/syntax errors in the code.

* Print out parse trees for syntactically correct SPL programs
* For errors, recognize
  * Lexical error (error type A) when there are undefined characters or tokens in the SPL
    program, or identifiers starting with digits.
  * Syntax error (error type B) when the program has an illegal structure, such as missing
    closing symbol. Please nd as many syntax errors as possible.
* Print line number of the error code
* Support hexadecimal representation of integers
* Support hex-form characters

For bonus part, we implemented single and multiline comment.

### 1.2 Development Environment

* `Ubuntu 20.04.2 LTS x86_64` with `Linux 5.8.0-50-generic`
* `g++ (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0`
* `flex 2.6.4`
* `bison (GNU Bison) 3.5.1`
* `GNU Make 4.2.1`

## 2 Design and Implementation

### 2.1 Tree Construction



### 2.2 Lexer

#### 2.2.1 Token Recognition

Referring to `token.txt`, write rules to return these tokens. And for `int, float, char`, write corresponding regular expressions. What's more, for each token, create a leaf node and use `yylval` to pass the node to parser. Therefore, we can construct the whole tree in parser.

#### 2.2.2 Error Detection

There are three types of error:

* Illegal hex int

  Write regular expression

### 2.3 Parser

