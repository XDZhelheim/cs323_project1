#pragma once

#include <vector>
#include <initializer_list>
#include <string>

using std::vector;
using std::initializer_list;
using std::string;

struct TreeNode;

enum DataType {
    INT, FLOAT, CHAR, OP, CHILD
};

TreeNode *make_op_node(string name)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::OP;
    return node;
}

TreeNode *make_int_node(string name, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::INT;
    node->data = val;
    return node;
}

TreeNode *make_float_node(string name, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::FLOAT;
    node->data = val;
    return node;
}

TreeNode *make_char_node(string name, string val)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::CHAR;
    node->data = val;
    return node;
}

TreeNode *make_child_node(string name, initializer_list<TreeNode *> child)
{
    TreeNode *node = new TreeNode;
    node->name = name;
    node->type = DataType::CHILD;
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
    TreeNode *parent;
    string data;
    vector<TreeNode *> child;
};

