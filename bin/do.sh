#!/bin/bash

function grammuelle_do () {
  echo "\n@include Do('$1') {\n  $2\n}" >> ./__stylebook__.scss;
}

alias grammuelle\.do=grammuelle_do

grammuelle.do "$@"
