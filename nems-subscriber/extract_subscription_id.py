import json


def extract_subscription_id_from_headers(headers):
    if 'Location' in headers:
        location = headers['Location']
        return location.split('STU3/Subscription/')[1]
    else:
        raise Exception('Unable to extract location from message headers')
