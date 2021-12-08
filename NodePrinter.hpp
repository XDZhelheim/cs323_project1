#ifndef NODE_PRINTER_HPP
#define NODE_PRINTER_HPP

#include "TreeNode.hpp"

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
        if (node->type == DataType::CHILD && node->child.size() == 0)
        {
            return;
        }
        for (int i = 0; i < depth; i++)
        {
            out << "  ";
        }
        if (node->type == DataType::TYPE_TYPE)
        {
            out << "TYPE: " << node->data << endl;
        }
        else if (node->type == DataType::CHAR_TYPE)
        {
            out << "CHAR: " << node->data << endl;
        }
        else if (node->type == DataType::INT_TYPE)
        {
            out << "INT: " << strtol(node->data.c_str(), NULL, 0) << endl;
        }
        else if (node->type == DataType::FLOAT_TYPE)
        {
            out << "FLOAT: " << node->data << endl;
        }
        else if (node->type == DataType::ID_TYPE)
        {
            out << "ID: " << node->data << endl;
        }
        else if (node->type == DataType::OTHER)
        {
            out << node->name << endl;
        }
        else
        {
            out << node->name << " (" << node->pos << ")" << endl;
            for (auto c : node->child)
            {
                recursive_print(c, depth + 1);
            }
        }
    }
};

void PrintTreeNode(char *file_path)
{
    string path = file_path;
    string out_path = "/dev/stdout";
    if (path.substr(path.length() - 4) == ".spl")
    {
        out_path = path.substr(0, path.length() - 4) + ".out";
    }
    Printer(root, out_path).print();
}

#endif