#!/bin/bash

. functions

exist ./text.txt "hello"

add_line ./text.txt "bonjour"

replace_line ./text.txt "bonjour" "salut"

remove_line ./text.txt "salut"

save_files ./save_list

restore_files ./save_list


