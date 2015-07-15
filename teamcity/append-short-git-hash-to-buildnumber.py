#!/usr/bin/python

import argparse, logging, sys

logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

parser = argparse.ArgumentParser(add_help=True, description='Gets an AMI running as blue')

parser.add_argument('--buildnumber', dest="build_number", required=True, help='The TeamCity build number')
parser.add_argument('--githash', dest="git_hash", required=True, help='The long git hash that is to be shortened')

try:
	results = parser.parse_args()
	short_git_hash = results.git_hash[0:7]
	print "##teamcity[buildNumber '" + results.build_number + "." + short_git_hash + "']"
except:
	logging.error('Failed to set build number', exc_info=True)
	exit(1)