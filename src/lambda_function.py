#!/usr/bin/python3.6
import urllib3
import json
import os

http = urllib3.PoolManager()
def lambda_handler(event, context):
    url = os.environ['SLACK_WEBHOOK']
    msg = {
        "channel": os.environ['SLACK_CHANNEL'],
        "username": os.environ['SLACK_USERNAME'],
        "text": event['Records'][0]['Sns']['Message']['AlarmName'] + ":" + event['Records'][0]['Sns']['Message']['AlarmDescription'],
        "icon_emoji": ""
    }
    
    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST',url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message']['AlarmName'] + ":" + event['Records'][0]['Sns']['Message']['AlarmDescription'],
        "status_code": resp.status,
        "response": resp.data
    })
