import requests
import os
from generate_auth_token import generate_auth_token


asid = os.environ['OUR_ASID']
ods_code = os.environ['OUR_ODS_CODE']
api_host = os.environ['API_HOST']
mesh_mailbox_id = os.environ['MESH_MAILBOX_ID']

token = generate_auth_token(asid, api_host, ods_code)

print('Requesting Create Subscription...')
subscribe_payload = '<Subscription xmlns="http://hl7.org/fhir">' + \
                    '<meta>' + \
                    '	<profile value="https://fhir.nhs.uk/STU3/StructureDefinition/EMS-Subscription-1"/>' + \
                    '</meta>' + \
                    '<status value="requested"/>' + \
                    '<contact>' + \
                    '	<system value="url"/>' + \
                    f'	<value value="https://directory.spineservices.nhs.uk/STU3/Organization/{ods_code}"/>' + \
                    '	<use value="work"/>' + \
                    '</contact>' + \
                    '<reason value="To facilate GP2GP transfer of EHR for suspended patients from their previous practise"/>' + \
                    f'<criteria value="/Bundle?type=message&amp;subscriptionRuleType=HSS&amp;Organization.identifier={ods_code}&amp;MessageHeader.event=pds-change-gp-1" />' + \
                    '<channel>' + \
                    '	<type value="message"/>' + \
                    f'	<endpoint value="{mesh_mailbox_id}"/>' + \
                    '</channel>' + \
                    '</Subscription>'

r = requests.post(
    f"http://{api_host}/STU3/Subscription",
    data=subscribe_payload,
    headers={
        'fromASID': asid,
        'toASID': '111111111111',
        'Authorization': token,
        'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiPost'
    })

print('Requested', r.status_code, r.headers, r.content)
