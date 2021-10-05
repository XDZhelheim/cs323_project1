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

TreeNode *make_op_node(string name, struct YYLTYPE position)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::OP;
    node->pos = position;
    return node;
}

TreeNode *make_int_node(string name, struct YYLTYPE position, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::INT;
    node->pos = position;
    node->data = val;
    return node;
}

TreeNode *make_float_node(string name, struct YYLTYPE position, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::FLOAT;
    node->pos = position;
    node->data = val;
    return node;
}

TreeNode *make_char_node(string name, struct YYLTYPE position, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::CHAR;
    node->pos = position;
    node->data = val;
    return node;
}

TreeNode *make_id_node(string name, struct YYLTYPE position, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::ID;
    node->pos = position;
    node->data = val;
    return node;
}

TreeNode *make_type_node(string name, struct YYLTYPE position, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::TYPE;
    node->pos = position;
    node->data = val;
    return node;
}

TreeNode *make_child_node(string name, struct YYLTYPE position, initializer_list<TreeNode *> child)
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

