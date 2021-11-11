import os

from dataclasses import dataclass
from typing import Optional


@dataclass
class Config:
    repo_asid: str
    ods_code: str
    nems_url: str
    nhs_env: str
    mesh_mailbox_id: str
    nems_asid: str
    nems_subscription_id: Optional[str] = None
    nems_event_code: Optional[str] = 'pds-change-of-gp-1'

def _read_env_var(name, required=True):
    value = os.getenv(name)
    if required and (value is None or value == ''):
        raise EnvironmentError(f'Required environment variable parameter {name} is missing')
    return value


def read_subscribe_config_from_env():
    return Config(
        repo_asid = _read_env_var('OUR_ASID'),
        ods_code = _read_env_var('OUR_ODS_CODE'),
        nems_url = _read_env_var('NEMS_URL'),
        nhs_env = _read_env_var('NHS_ENVIRONMENT', required=False),
        mesh_mailbox_id = _read_env_var('MESH_MAILBOX_ID', required=False),
        nems_event_code = _read_env_var('NEMS_EVENT_CODE', required=False),
        nems_subscription_id = _read_env_var('NEMS_SUBSCRIPTION_ID', required=False),
        nems_asid = _read_env_var('NEMS_ASID', required=False))
