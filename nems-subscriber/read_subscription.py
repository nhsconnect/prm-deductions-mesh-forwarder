import requests

from config import read_subscribe_config_from_env
from generate_auth_token import generate_auth_token


def read_subscription(config):
    token = generate_auth_token(config.repo_asid, config.nems_url, config.ods_code)

    print('Requesting Retrieve Subscription...')

    r = requests.get(
        f"{config.nems_url}/STU3/Subscription/{config.nems_subscription_id}",
        headers={
            'Accept': 'application/fhir+xml;charset=utf-8',
            'fromASID': config.repo_asid,
            'toASID': config.nems_asid,
            'Authorization': f'Bearer {token}',
            'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiGet'
        },
        cert=(f"../certs/{config.nhs_env}/nems-client.crt", f"../certs/{config.nhs_env}/nems-client.key"),
        verify=f"../certs/{config.nhs_env}/nems-ca-certs.crt")
    print('Requested', r.status_code, r.headers, r.content)
    return r.status_code


if __name__ == "__main__":
    read_subscription(read_subscribe_config_from_env())
