#!/bin/bash

function grammuelle_do () {
  IFS=';' read -ra commandlist <<< "$2";
  stylebook="./__stylebook__.scss";
  export INDENT="  ";
  proplist="";
  for i in "${commandlist[@]}"; do
    proplist+=$i";\n ";
  done
  echo "\n@include Do('$1') {\n  $proplist\n}" >> $stylebook;
  echo "Added \"$1\" to the style book with the following properties:\n"
  echo "$INDENT$proplist";
}

alias grammuelle\.do=grammuelle_do

grammuelle.do "$@"
