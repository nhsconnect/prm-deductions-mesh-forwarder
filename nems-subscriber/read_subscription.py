import requests
import os
from generate_auth_token import generate_auth_token

asid = os.environ['OUR_ASID']
ods_code = os.environ['OUR_ODS_CODE']
api_host = os.environ['API_HOST']
nems_subscription_id = os.environ['NEMS_SUBSCRIPTION_ID']

token = generate_auth_token(asid, api_host, ods_code)
print(token)


print('Requesting Retrieve Subscription...')

r = requests.get(
    f"http://{api_host}/STU3/Subscription/{nems_subscription_id}",
    headers={
        'fromASID': asid,
        'toASID': '111111111111',
        'Authorization': token,
        'InteractionID': 'urn:nhs:names:services:clinicals-sync:SubscriptionsApiGet'
    })

print('Requested', r.status_code, r.headers, r.content)
