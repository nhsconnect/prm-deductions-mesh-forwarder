import time
import requests
import os

import jwt

asid = os.environ['OUR_ASID']
org_code = os.environ['OUR_ORG_CODE']
api_host = os.environ['API_HOST']
mesh_mailbox_id = os.environ['MESH_MAILBOX_ID']

now = int(time.time())
jwt_payload_data = {
    'scope': 'patient/Subscription.write',
    'sub': asid,
    'requesting_system': asid,
    'reason_for_request': 'secondary-uses'
}

token = jwt.encode(
    payload=jwt_payload_data, 
    key=None,
    algorithm=None
)

print(token)

print('Requesting Subscription...')
subscribe_payload = '<Subscription xmlns="http://hl7.org/fhir">' + \
    '<meta>' + \
	'	<profile value="https://fhir.nhs.uk/STU3/StructureDefinition/EMS-Subscription-1"/>' + \
	'</meta>' + \
	'<status value="requested"/>' + \
	'<contact>' + \
	'	<system value="url"/>' + \
	f'	<value value="https://directory.spineservices.nhs.uk/STU3/Organization/{org_code}"/>' + \
	'	<use value="work"/>' + \
	'</contact>' + \
	'<reason value="To facilate GP2GP transfer of EHR for suspended patients from their previous practise"/>' + \
	f'<criteria value="/Bundle?type=message&amp;subscriptionRuleType=HSS&amp;Organization.identifier={org_code}&amp;MessageHeader.event=pds-change-gp-1" />' + \
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
