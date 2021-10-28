import os

from dataclasses import dataclass

@dataclass
class Config:
    asid: str
    ods_code: str
    api_host: str
    mesh_mailbox_id: str
    nems_subscription_id: str

def _read_env_var(name, required=True):
    value = os.getenv(name)
    if required and value is None:
        raise EnvironmentError(f'Required environment variable parameter {name} is missing')
    return value

def read_subscribe_config_from_env():
    return Config(
        asid = _read_env_var('OUR_ASID'), 
        ods_code = _read_env_var('OUR_ODS_CODE'), 
        api_host = _read_env_var('API_HOST'),
        mesh_mailbox_id = _read_env_var('MESH_MAILBOX_ID', required=False),
        nems_subscription_id = _read_env_var('NEMS_SUBSCRIPTION_ID', required=False))
