from unittest.mock import Mock

from subscribe import Config

def ensure_subscription_exists(subscription_reader, subscription_creator, config: Config):
    if not subscription_reader().status_code == 200:
        subscription_creator(config.asid, config.ods_code, config.api_host, config.mesh_mailbox_id)


def test_that_when_subscription_does_not_exist_it_is_created():
    config = Config(asid="A1", ods_code="ods", api_host="host", mesh_mailbox_id="mesh", nems_subscription_id="sub")
    reader = Mock(status_code=404)
    creator = Mock()

    ensure_subscription_exists(reader, creator, config)

    creator.assert_called_once_with(config.asid, config.ods_code, config.api_host, config.mesh_mailbox_id)

def test_that_when_subscription_does_exist_it_is_not_recreated():
    config = Config(asid="A1", ods_code="ods", api_host="host", mesh_mailbox_id="mesh", nems_subscription_id="sub")
    a_subscription={'name': 'bob'}
    reader = Mock(return_value=Mock(status_code=200))
    creator = Mock()

    ensure_subscription_exists(reader, creator, config)

    creator.assert_not_called()





