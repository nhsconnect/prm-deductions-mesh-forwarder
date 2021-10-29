import time
import jwt


def generate_auth_token(asid, nems_url, ods_code):
    now = int(time.time())
    five_minutes_from_now = now + 300

    jwt_payload_data = {
        'iss': '',
        'sub': asid,
        'aud': nems_url,
        'exp': five_minutes_from_now,
        'iat': now,
        'reason_for_request': 'secondary-uses',
        'scope': 'patient/Subscription.write',
        'requesting_system': asid,
        'requesting_organisation': f"https://fhir.nhs.uk/Id/ods-organization-code|[${ods_code}]",
    }

    token = jwt.encode(
        payload=jwt_payload_data,
        key=None,
        algorithm=None
    )

    print(token)
    return token
