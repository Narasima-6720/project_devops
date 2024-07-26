import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    # Get all EBS snapshots
    snapshots_response = ec2.describe_snapshots(OwnerIds=['self'])

    # Get all active EC2 instance IDs
    instances_response = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    active_instance_ids = set()

    for reservation in instances_response['Reservations']:
        for instance in reservation['Instances']:
            active_instance_ids.add(instance['InstanceId'])

    # Get all volumes
    volumes_response = ec2.describe_volumes()
    volumes = {volume['VolumeId']: volume for volume in volumes_response['Volumes']}

    # Iterate through each snapshot
    for snapshot in snapshots_response['Snapshots']:
        snapshot_id = snapshot['SnapshotId']
        volume_id = snapshot['VolumeId']

        if volume_id in volumes:
            volume = volumes[volume_id]
            if not volume['Attachments']:
                # Volume exists but is not attached to any instance
                ec2.delete_snapshot(SnapshotId=snapshot_id)
                print(f"Deleted EBS snapshot {snapshot_id} as its volume is not attached to any instance.")
            else:
                attached_instance_id = volume['Attachments'][0]['InstanceId']
                if attached_instance_id not in active_instance_ids:
                    # Volume is attached to an instance that is not running
                    ec2.delete_snapshot(SnapshotId=snapshot_id)
                    print(f"Deleted EBS snapshot {snapshot_id} as its volume is attached to a stopped instance.")

        else:
            # The volume associated with the snapshot is not found (it might have been deleted)
            ec2.delete_snapshot(SnapshotId=snapshot_id)
            print(f"Deleted EBS snapshot {snapshot_id} as its associated volume was not found.")
