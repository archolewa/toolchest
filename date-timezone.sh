#!/bin/sh

originalTZ=$TZ
export TZ=$1
date
export TZ=$originalTZ
