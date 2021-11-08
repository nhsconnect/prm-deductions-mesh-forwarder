import requests
from generate_auth_token import generate_auth_token
from config import read_subscribe_config_from_env


def delete_subscription(config):
    token = generate_auth_token(config.asid, config.nems_url, config.ods_code)

    print('Requesting Delete Subscription...')

    r = requests.delete(
        f"{config.nems_url}/STU3/Subscription/{config.nems_subscription_id}",
        headers={
            'Accept': 'application/fhir+xml;charset=utf-8',
            'fromASID': config.asid,
            'toASID': '111111111111',
            'Authorization': f'Bearer {token}',
            'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiDelete'
        })

    print('Requested', r.status_code, r.headers, r.content)
    return r


if __name__ == "__main__":
    delete_subscription(read_subscribe_config_from_env())
