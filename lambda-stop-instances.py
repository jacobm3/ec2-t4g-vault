import boto3
import json

def lambda_handler(event, context):
    ec2r = boto3.resource('ec2')
    ec2c = boto3.client('ec2')

    for instance in ec2r.instances.all():
        print (instance.id , instance.state)
        if instance.state['Name'] == 'running':
            print ('Stopping %s' % instance.id)
            ec2c.stop_instances(InstanceIds=[instance.id])

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
