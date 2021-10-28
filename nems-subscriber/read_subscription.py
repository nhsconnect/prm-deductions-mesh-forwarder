import requests
import os

from config import read_subscribe_config_from_env
from generate_auth_token import generate_auth_token


def read_subscription(config):
    token = generate_auth_token(config.asid, config.api_host, config.ods_code)
    print(token)


    print('Requesting Retrieve Subscription...')

    r = requests.get(
        f"http://{config.api_host}/STU3/Subscription/{config.nems_subscription_id}",
        headers={
            'fromASID': config.asid,
            'toASID': '111111111111',
            'Authorization': token,
            'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiGet'
        })

    print('Requested', r.status_code, r.headers, r.content)
    return r.status_code

if __name__ == "__main__":
    read_subscription(read_subscribe_config_from_env())