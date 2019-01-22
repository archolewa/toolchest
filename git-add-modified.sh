#!/bin/bash

git add `git status | fgrep modified | cut -d ":" -f 2`
