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

    r = requests.post(
        f"{config.nems_url}/STU3/Subscription",
        data=subscribe_payload,
        headers={
            'fromASID': config.asid,
            'toASID': '111111111111',
            'Authorization': token,
            'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiPost'
        })

    print('Requested', r.status_code, r.headers, r.content)
    return r.status_code


if __name__ == "__main__":
    create_subscription(read_subscribe_config_from_env())
