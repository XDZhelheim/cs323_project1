#pragma once

#include <vector>
#include <initializer_list>
#include <string>
#include <fstream>
#include "YYLTYPE.h"

using std::vector;
using std::initializer_list;
using std::string;
using std::ofstream;
using std::endl;

struct TreeNode;

enum DataType {
    INT, FLOAT, CHAR, ID, TYPE, CHILD, OTHER
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

class Printer
{
private:
    TreeNode *root;
    ofstream out;

public:
    Printer(TreeNode *node, string path)
    {
        root = node;
        out = ofstream(path);
    }

    void print() 
    {
        recursive_print(root, 0);
    }

    void recursive_print(TreeNode *node, int depth)
    {
        for (int i = 0; i < depth; i++)
        {
            out << "  ";
        }
        if (node->type == DataType::TYPE)
        {
            out << "TYPE: " << node->data << endl;
        } else if (node->type == DataType::CHAR)
        {
            out << "CHAR: " << node->data << endl;
        }
        
    }
};

void PrintTreeNode(TreeNode *root, char *file_path)
{
    string path = file_path;
    string out_path = "/dev/stdout";
    if (path.substr(path.length() - 4) == ".spl")
    {
        out_path = path.substr(path.length() - 4) + ".out";
    }
    Printer(root, out_path).print();
}