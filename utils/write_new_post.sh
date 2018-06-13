#!/bin/bash

if [ -z "$1" ]; then
    echo
    echo "Please give the title for the new posts"
    echo "example:"
    echo "   ./write_new_post \"Phil Huang is a handsome man\" "
    echo 
else
  echo "Please type \"hexo new <topic>"\""
fi
