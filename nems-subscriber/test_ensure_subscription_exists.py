import pytest
from unittest.mock import Mock


def ensure_subscription_exists(subscription_reader, subscription_creator):
    if not subscription_reader():
        subscription_creator()

def test_that_when_subscription_does_not_exist_it_is_created():
    reader = Mock(return_value=None)
    creator = Mock()

    ensure_subscription_exists(reader, creator)

    creator.assert_called_once()

def test_that_when_subscription_does_exist_it_is_not_recreated():
    a_subscription={'name': 'bob'}
    reader = Mock(return_value=a_subscription)
    creator = Mock()

    ensure_subscription_exists(reader, creator)

    creator.assert_not_called()





