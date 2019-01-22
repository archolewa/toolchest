#!/bin/bash

git status | fgrep modified | cut -d ":" -f 2
