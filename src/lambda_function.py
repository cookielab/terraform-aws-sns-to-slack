#!/usr/bin/python3.6
import urllib3
import json
import os

http = urllib3.PoolManager()
def lambda_handler(event, context):
    url = os.environ['SLACK_WEBHOOK']

    message = json.loads(json.loads(json.dumps(event))["Records"][0]["Sns"]["Message"])

    color = "danger" if message['NewStateValue'] == "ALARM" else "good"
    emoji = ":red_circle:" if message['NewStateValue'] == "ALARM" else ":large_green_circle:"

    msg = {
        "channel": os.environ['SLACK_CHANNEL'],
        "username": os.environ['SLACK_USERNAME'],

        "attachments": [{
                "color": color,
                "fallback": message['AlarmName'] + ":" + message['AlarmDescription'],
                "fields": [
                    {"title": "Alarm", "value": emoji+ " " + message['AlarmName']},
                    {"title": "Message", "value": message['AlarmDescription']},
                    {"title": "Reason", "value": message['NewStateReason']}
                ]
            }
        ],
        "icon_emoji": emoji
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST',url, body=encoded_msg)
    print(message)
