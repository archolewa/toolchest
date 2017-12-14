#!/bin/bash

git add `git status | ag modified | cut -d ":" -f 2`
