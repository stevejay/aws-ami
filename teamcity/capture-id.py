#!/usr/bin/python

import argparse, logging, sys, re

logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

parser = argparse.ArgumentParser(add_help=True, description='Gets AMI ID from packer log file')

parser.add_argument('--infile', '-i', metavar='in-file', type=argparse.FileType('rt'), dest='in_file', required=True, help='The packer log file')
parser.add_argument('--regex', '-r', dest="regex", required=True, help='The regex to find the ID')
parser.add_argument('--parameter', '-p', dest="parameter", required=True, help='The TeamCity parameter name to set')

try:
	results = parser.parse_args()
	
	with results.in_file as source_file:
		content = source_file.read()
		match = re.search(results.regex, content)
		if not match: raise Exception('no match found for regex')
		print "##teamcity[setParameter name='" + results.parameter + "' value='" + match.group(1) + "']"
except:
	logging.error('Failed to capture ID', exc_info=True)
	exit(1)
