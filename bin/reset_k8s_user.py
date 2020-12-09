import yaml
import sys
import os
import argparse


def print_users():
    for user in config['users']:
        if 'auth-provider' in user['user'].keys():
            # kubernetes user
            if 'expires-on' in user['user']['auth-provider']['config'].keys():
                # authentication has ever happened
                print(user['name'])


def delete_lines(cluster_user):
    for user in config['users']:
        if user['name'] == cluster_user:
                del user['user']['auth-provider']['config']['access-token']
                del user['user']['auth-provider']['config']['expires-in']
                del user['user']['auth-provider']['config']['expires-on']
                del user['user']['auth-provider']['config']['refresh-token']
                yaml.dump(config, stream)


if __name__ == "__main__":
    with open(os.path.expanduser('~/.kube/config'), 'r+') as stream:
        try:
            config = yaml.safe_load(stream)

            print('Found following k8s users:')
            print_users()

            name = input('Paste the name of the user for which to delete old k8s token:')
            delete_lines(name)

        except yaml.YAMLError as exc:
            print(exc)
