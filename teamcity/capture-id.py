#!/usr/bin/python

import argparse, logging, sys, re

logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

parser = argparse.ArgumentParser(add_help=True, description='Gets an ID from a file and uses it to set a TeamCity parameter')

parser.add_argument('--infile', '-i', metavar='in-file', type=argparse.FileType('rt'), dest='in_file', required=True, help='The file to search')
parser.add_argument('--regex', '-r', dest="regex", required=True, help='The regex to find the ID')
parser.add_argument('--parameter', '-p', dest="parameter", required=True, help='The TeamCity parameter name to set')

try:

	results = parser.parse_args()
	content = '';
	
	with results.in_file as source_file:
		content = source_file.read()
		
	match = re.search(results.regex, content)
	if not match: raise Exception('no match found for regex')
	id = match.group(1)
		
	print "##teamcity[setParameter name='" + results.parameter + "' value='" + id + "']"
		
	with open(results.parameter + '.txt', 'w') as dest_file:
		dest_file.write(id);
	
except:
	logging.error('Failed to capture ID', exc_info=True)
	exit(1)
