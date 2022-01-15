from flask import Flask, request
import boto3


APP = Flask(__name__)

session = boto3.Session(profile_name='default')
CLIENT = session.client("sns")


@APP.route('/sendsms', methods=['POST'])
def sendsms():
    number = "+" + request.args.get('number')
    print(number)
    message = 'AAAAAAAAAAAAAAAAAAAAH!'
    print(message)

    response = CLIENT.publish(
        PhoneNumber=number,
        Message='AAAAAAAAAAAAAAAAAAAAH!',
        MessageAttributes={
            'AWS.SNS.SMS.SenderID':
            {
                'DataType': 'String',
                'StringValue': 'Grafana'
            }
        }
    )
    return response
