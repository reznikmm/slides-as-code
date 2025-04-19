#!/bin/bash
HERE=$(dirname $0)
# to find gtk.css in $XDG_CONFIG_HOME/gtk-3.0/
XDG_CONFIG_HOME=$HERE $HERE/bin/hello_world