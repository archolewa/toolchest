#!/bin/bash

git status | ag modified | cut -d ":" -f 2
