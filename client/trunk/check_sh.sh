#!/bin/bash

function _do()
{
	$@ || { echo "exec failed : " $1 ""; exit -1; }
}