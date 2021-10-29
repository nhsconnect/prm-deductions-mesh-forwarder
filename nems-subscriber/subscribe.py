from config import Config


def create_subscription_if_not_exists(subscription_reader, subscription_creator, config: Config):
    if not config.nems_subscription_id:
        return subscription_creator(config)

    read_result = subscription_reader(config)
    if not read_result == 200:
        return subscription_creator(config)

    return config.nems_subscription_id
