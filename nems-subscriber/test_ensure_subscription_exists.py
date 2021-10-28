from unittest.mock import Mock

from subscribe import Config, ensure_subscription_exists


def test_that_when_subscription_does_not_exist_it_is_created():
    config = Config(asid="A1", ods_code="ods", api_host="host", mesh_mailbox_id="mesh", nems_subscription_id="sub")
    reader = Mock(return_value=404)
    creator = Mock(return_value=201)

    result = ensure_subscription_exists(reader, creator, config)

    creator.assert_called_once_with(config)
    assert result == 201

def test_that_when_subscription_does_exist_it_is_not_recreated():
    config = Config(asid="A1", ods_code="ods", api_host="host", mesh_mailbox_id="mesh", nems_subscription_id="sub")

    reader = Mock(return_value=200)
    creator = Mock()

    result = ensure_subscription_exists(reader, creator, config)

    creator.assert_not_called()
    assert result == 200





