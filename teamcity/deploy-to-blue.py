#!/usr/bin/python

import argparse, boto3, logging, sys

logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

parser = argparse.ArgumentParser(add_help=True, description='Gets an AMI running as blue')

parser.add_argument('--launchconfigname', dest="launch_config_name", required=True, help='The name of the launch configuration')
parser.add_argument('--imageid', dest="image_id", required=True, help='The AMI to use in the auto-scaling group')
parser.add_argument('--keyname', dest="key_name", required=True, help='The key name to use')
parser.add_argument('--securitygroup', dest="security_group", required=True, help='The security group ID to use')
parser.add_argument('--environment', dest="environment", required=True, help='The environment to set in the user data')
parser.add_argument('--instancetype', dest="instance_type", required=True, help='The instance type to fire up')
parser.add_argument('--iaminstanceprofile', dest="iam_instance_profile", required=True, help='The IAM instance profile')
parser.add_argument('--maxinstances', dest="max_instances", required=True, help='Maximum number of instance in the auto scaling group')
parser.add_argument('--normalinstancecount', dest="normal_instance_count", required=True, help='The desired normal number of instance in the auto scaling group')
parser.add_argument('--subnetid', dest="subnet_id", required=True, help='The VPC zone identifier for the auto scaling group')

client = boto3.client('autoscaling')
created_launch_configuration = False
created_auto_scaling_group = False

try:
	results = parser.parse_args()
	
	user_data = results.environment
	
	client.create_launch_configuration(
		LaunchConfigurationName=results.launch_config_name,
		ImageId=results.image_id,
		KeyName=results.key_name,
		SecurityGroups=[
			results.security_group,
		],
		#ClassicLinkVPCId='string',
		#ClassicLinkVPCSecurityGroups=[
		#	'string',
		#],
		UserData=user_data,
		#InstanceId='string',
		InstanceType=results.instance_type,
		#KernelId='string',
		#RamdiskId='string',
		#BlockDeviceMappings=[
		#	{
		#		'VirtualName': 'string',
		#		'DeviceName': 'string',
		#		'Ebs': {
		#			'SnapshotId': 'string',
		#			'VolumeSize': 123,
		#			'VolumeType': 'string',
		#			'DeleteOnTermination': True|False,
		#			'Iops': 123
		#		},
		#		'NoDevice': True|False
		#	},
		#],
		InstanceMonitoring={
			'Enabled': False
		},
		#SpotPrice='string',
		IamInstanceProfile=results.iam_instance_profile,
		EbsOptimized=False,
		AssociatePublicIpAddress=False,
		PlacementTenancy='default'
	)
	
	created_launch_configuration = True
	auto_scaling_group_name = results.launch_config_name + '-asg'
	
	response = client.create_auto_scaling_group(
		AutoScalingGroupName=auto_scaling_group_name,
		LaunchConfigurationName=results.launch_config_name,
		#InstanceId='string',
		MinSize=1,
		MaxSize=int(results.max_instances),
		DesiredCapacity=int(results.normal_instance_count),
		DefaultCooldown=450,
		#AvailabilityZones=[
		#	'string',
		#],
		LoadBalancerNames=[
			'walkdesigner-lb-1',
		],
		#HealthCheckType='string',
		HealthCheckGracePeriod=450,
		#PlacementGroup='string',
		VPCZoneIdentifier=results.subnet_id, # ??????????????
		TerminationPolicies=[
			'Default',
		],
		#Tags=[
		#	{
		#		'ResourceId': 'string',
		#		'ResourceType': 'string',
		#		'Key': 'string',
		#		'Value': 'string',
		#		'PropagateAtLaunch': True|False
		#	},
		#]
	)

	created_auto_scaling_group = True
	
except:
	if created_launch_configuration:
		try:
			client.delete_launch_configuration(LaunchConfigurationName=results.launch_config_name)
		except:
			logging.error('Failed to roll back creation of launch configuration')
			
	if created_auto_scaling_group:
		try:
			client.delete_auto_scaling_group(AutoScalingGroupName=auto_scaling_group_name, ForceDelete=True)
		except:
			logging.error('Failed to roll back creation of auto scaling group')
		
	logging.error('Failed to deploy to blue', exc_info=True)
	exit(1)
