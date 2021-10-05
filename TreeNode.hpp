#pragma once

#include <vector>
#include <initializer_list>
#include <string>
#include "YYLTYPE.h"

using std::vector;
using std::initializer_list;
using std::string;

struct TreeNode;

enum DataType {
    INT, FLOAT, CHAR, OP, ID, TYPE, CHILD
};

TreeNode *create_node(string name, struct YYLTYPE position, DataType type, string val="")
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = type;
    node->pos = position;
    node->data = val;
    return node;
}

TreeNode *create_child_node(string name, struct YYLTYPE position, initializer_list<TreeNode *> child)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::CHILD;
    node->pos = position;
    for (auto c : child) {
        c->parent = node;
        node->child.push_back(c);
    }
    return node;
}

struct TreeNode
{
    string name;
    DataType type;
    YYLTYPE pos;
    TreeNode *parent;
    string data;
    vector<TreeNode *> child;
};

