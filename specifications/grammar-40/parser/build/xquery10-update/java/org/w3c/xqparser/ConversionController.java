

package org.w3c.xqparser;

import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.util.Stack;

public class ConversionController
{
    protected XMLWriter xw;
    public String[] component_id_;
    protected XQueryXConverter[] xqxc_;

    public ConversionController() throws UnsupportedEncodingException
    {
        xw = new XMLWriter();
        xw.setOutputs(System.out, null);

        component_id_ = new String[] {
            "xquery10",
            "update10",
            "dummy",
        };

        xqxc_ = new XQueryXConverter[] {
            new XQueryXConverter_xquery10(this, xw),
            new XQueryXConverter_update10(this, xw),
            new XQueryXConverter_dummy(this, xw),
        };
    }

    // -------------------------------------------------------------------------

    public void transform(SimpleNode node, PrintStream ps1)
        throws UnsupportedEncodingException
    {
        xw.setOutputs(ps1, null);
        transform(node);
        xw.flush();
    }

    public void transform(SimpleNode node, PrintStream ps1, PrintStream ps2)
        throws UnsupportedEncodingException
    {
        xw.setOutputs(ps1, ps2);
        transform(node);
        xw.flush();
    }

    public void transformNoEncodingException(
        SimpleNode node, PrintStream ps1, PrintStream ps2)
    {
        xw.setOutputs_NoEncodingException(ps1, ps2);
        transform(node);
        xw.flush();
    }

    // -------------------------------------------------------------------------

    public void transform(SimpleNode node)
    {
        int markSize = xw.getDepthOfOpenElementStack();

        boolean node_has_been_handled = false;
        int n = xqxc_.length;
        for (int i = n-1; i >= 0; i--)
        {
            boolean result = xqxc_[i].transformNode(node);
            if (result)
            {
                node_has_been_handled = true;
                break;
            }
        }
        if (!node_has_been_handled)
        {
            throw new RuntimeException(
                "Converter did not know how to handle " + node.toString()
            );
        }

        int currentSize = xw.getDepthOfOpenElementStack();
        if (markSize != currentSize)
            throw new RuntimeException(
                "Unbalanced tags! transformNode(" + node.toString() + ") opened "
                + Integer.toString(currentSize - markSize)
                + " more elements than it closed."
            );
    }

    // -------------------------------------------------------------------------

    public void transformChildren(SimpleNode node)
    {
        transformChildren(node, 0, node.jjtGetNumChildren() - 1);
    }

    public void transformChildren(SimpleNode node, int start)
    {
        transformChildren(node, start, node.jjtGetNumChildren() - 1);
    }

    public void transformChildren(SimpleNode node, int start, int end)
    {
        // int n = node.jjtGetNumChildren();
        for (int i = start; i <= end; i++)
        {
            SimpleNode child = node.getChild(i);
            transform(child);
        }
    }

}
