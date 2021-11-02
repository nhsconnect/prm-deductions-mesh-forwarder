import requests

from config import read_subscribe_config_from_env

from generate_auth_token import generate_auth_token


def create_subscription(config):
    token = generate_auth_token(config.asid, config.nems_url, config.ods_code)

    print('Requesting Create Subscription...')
    subscribe_payload = '<Subscription xmlns="http://hl7.org/fhir">' + \
                        '<meta>' + \
                        '	<profile value="https://fhir.nhs.uk/STU3/StructureDefinition/EMS-Subscription-1"/>' + \
                        '</meta>' + \
                        '<status value="requested"/>' + \
                        '<contact>' + \
                        '	<system value="url"/>' + \
                        f'	<value value="https://directory.spineservices.nhs.uk/STU3/Organization/{config.ods_code}"/>' + \
                        '	<use value="work"/>' + \
                        '</contact>' + \
                        '<reason value="To facilate GP2GP transfer of EHR for suspended patients from their previous practise"/>' + \
                        f'<criteria value="/Bundle?type=message&amp;subscriptionRuleType=HSS&amp;Organization.identifier={config.ods_code}&amp;MessageHeader.event=pds-change-gp-1" />' + \
                        '<channel>' + \
                        '	<type value="message"/>' + \
                        f'	<endpoint value="{config.mesh_mailbox_id}"/>' + \
                        '</channel>' + \
                        '</Subscription>'

    print('create payload', subscribe_payload)
    headers={
        'Accept': 'application/fhir+xml;charset=utf-8',
        'fromASID': config.asid,
        'toASID': '111111111111',
        'Authorization': f'Bearer {token}',
        'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiPost'
    }
    print('create headers', headers)
    url = f"{config.nems_url}/STU3/Subscription"
    print('create url', url)

    r = requests.post(
        url,
        data=subscribe_payload,
        headers=headers)

    print('Requested', r.status_code, r.headers, r.content)

    if r.status_code == 201:
        return extract_subscription_id_from_headers(r.headers)
    else:
        raise Exception(f"Error creating subscription: Status Code {r.status_code}. Error {r.content.decode()}")


def extract_subscription_id_from_headers(headers):
    if 'Location' in headers:
        location = headers['Location']
        return location.split('STU3/Subscription/')[1]
    else:
        raise Exception('Unable to extract location from message headers')


if __name__ == "__main__":
    create_subscription(read_subscribe_config_from_env())
