
from config import read_subscribe_config_from_env

from create_subscription import create_subscription
from read_subscription import read_subscription
from subscribe import create_subscription_if_not_exists


def ensure_subscribed(config=read_subscribe_config_from_env()):
    subscribed_nems_id = create_subscription_if_not_exists(subscription_creator=create_subscription,
                                                           subscription_reader=read_subscription, config=config)
    print(subscribed_nems_id)
    return subscribed_nems_id


if __name__ == "__main__":
    ensure_subscribed()
