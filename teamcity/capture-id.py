#!/usr/bin/python

import argparse, logging, sys

logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

parser = argparse.ArgumentParser(add_help=True, description='Gets AMI ID from packer log file')

parser.add_argument('--infile', '-i', metavar='in-file', type=argparse.FileType('rt'), dest='in_file', required=True, help='The packer log file')
parser.add_argument('--regex', '-r', dest="bucket", required=True, help='The regex to find the ID')
parser.add_argument('--parameter', '-p', dest="bucket", required=True, help='The TeamCity parameter name to set')

try:
	results = parser.parse_args()
	
	with results.in_file as source_file:
		boto3.resource('s3').Bucket(results.bucket).put_object(Key=results.out_file, Body=source_file)
except:
	logging.info('Failed to upload to s3', exc_info=False)
	exit(1)
