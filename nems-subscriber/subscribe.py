from config import read_subscribe_config_from_env, Config

from create_subscription import create_subscription
from read_subscription import read_subscription

def ensure_subscription_exists(subscription_reader, subscription_creator, config: Config):
    read_result = subscription_reader(config)
    if not read_result == 200:
        return subscription_creator(config)

    return read_result

def ensure_subscribed(config=read_subscribe_config_from_env()):
    return ensure_subscription_exists(subscription_creator=create_subscription, subscription_reader=read_subscription, config=config)