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

* `Ubuntu 18.04.6 LTS x86_64` with `Linux 5.4.0-87-generic`
* `gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0`
* `g++ (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0`
* `flex 2.6.4`
* `bison (GNU Bison) 3.0.4`
* `GNU Make 4.1`

## 2 Design and Implementation

### 2.1 Tree Construction

In `lex.l` and `syntax.y` , we call function `create_node` and `create_child_node` in `TreeNode.hpp` to generate `TreeNode` which is a part of tree struct .

```cpp
struct TreeNode
{
    string name; // name of the node
    DataType type; // type of this node
    int pos; // line number of this node
    TreeNode *parent; // parent node
    string data; // store int|float|char value as string to avoid overflow, also name of TYPE or ID
    vector<TreeNode *> child; // if this is a parent node, it will have child nodes
};
```

In `lex.l` , the generated node is returned by modifying `yylval` .

In `syntax.y` , the generated node is returned by modifying `$$` .

We make every token recognized a `TreeNode` . `create_node` function makes node with `int, float, char` value or an ID of variable or just a symbol like `+` , `;` and etc . `create_child_node` function makes node which has a sub-struct within this node as a code block `if-else` statement contains `IF, (, ), {, Exp, }, ELSE, {, Exp, }` . 

```cpp
enum DataType
{
    INT_TYPE, // for int
    FLOAT_TYPE, // for float
    CHAR_TYPE, // for char
    ID_TYPE, // for name of variable
    TYPE_TYPE, // for specifier
    CHILD, // for parent node
    OTHER // for symbols
};
```

We also define a `DataType` enum to specify the type of node to avoid defining multiple node. 

### 2.2 Lexer

#### 2.2.1 Token Recognition

Referring to `token.txt`, write rules to return these tokens. And for `int, float, char`, write corresponding regular expressions. What's more, for each token, create a leaf node and use `yylval` to pass the node to parser. Therefore, we can construct the whole tree in parser.

#### 2.2.2 Error Detection

Set a global variable `has_error` to control the main function to print parse tree or error messages.

There are three types of error:

* Undefined tokens
* Illegal hex int
* Illegal hex char

Write regular expressions to capture them. What is essential is that when error detected, we should still create a leaf node for parser and return a token. Only by this, the parser can continue analyzing. If not, there will be a missing token, which will lead to totally wrong shift/reduce steps after it.

For line number, use `%option yylineno`, as introduced in project document.

#### 2.2.3 Single and Multiline Comment

* Single line

  Read characters until meet `\n`, very simple.

  `"//" { while(yyinput() != '\n'); }`

* Multiline

  Since we should detect `*/`, which are two characters, use a buffer character to look ahead. If `*/` is not detected, return error.

  ```c
  "/*" {
      char c = 0;
      char buffer;
      while (buffer = yyinput()) {
          if (c == '*' && buffer == '/') {
              yycolno += 2;
              break;
          }
          if (c == '\n') {
              yycolno = 1; // yylineno will still auto-increase
          } else {
              yycolno++;
          }
          c = buffer;
      }
      if (buffer == 0) {
          fprintf(output_file, "Error type A at Line %d: Missing \"*/\"\n", yylineno);
          has_error = 1;
      }
  }
  ```

### 2.3 Parser

#### 2.3.1 Syntax Analysis

Referring to `syntax.txt`, write corresponding productions, and replace `$` by `%empty`.

Create a internal node for the pass tree. The children are the right side of the production.

#### 2.3.2 Error Detection

There are three types of error:

* Missing semicolon or comma
* Missing specifier
* Missing closing symbol

For each type of error, place `error` in every possible positions, and print error message.

For line number, use `@$` or `@1, @2, ...` (a struct) to get line or column numbers.

#### 2.3.3 Main Function

We define a `Printer` class to print the result. With some special case like `int, float, char, ID, TYPE` , we need to specify its type like `TYPE: ` and `data` of `TreeNode`, in other cases, for symbols only `name` is needed or for parent node `name` adding line number is needed, with indent of 2 spaces.

## 3 Conclusion
