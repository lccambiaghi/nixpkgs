import argparse
import os
import sys
from datetime import datetime

from azure.storage.blob.blockblobservice import BaseBlobService
from azure.storage.blob.models import ContainerPermissions


def cmd_generate_container_sas_token():
    parser = argparse.ArgumentParser(
        description="Generate a SAS token for the specifiec container. Storage key is in ACCOUNT_KEY environment variable"
    )
    parser.add_argument("--account", type=str, help="Storage account name", required=True)
    parser.add_argument("--container", type=str, help="Storage account container name", required=True)
    parser.add_argument(
        "--start_date", type=str, help="Key will expire midnight CET on the given date (YYYY-MM-DD)", required=False
    )
    parser.add_argument(
        "--expiry_date", type=str, help="Key will expire midnight CET on the given date (YYYY-MM-DD)", required=True
    )
    parser.add_argument("--read", action="store_true", help="Enable read permissions for the token")
    parser.add_argument("--write", action="store_true", help="Enable write permissions for the token")
    parser.add_argument("--delete", action="store_true", help="Enable delete permissions for the token")
    parser.add_argument("--list", action="store_true", help="Enable list permissions for the token")

    arguments = parser.parse_args()

    account_key = os.environ["ACCOUNT_KEY"]
    perms = ContainerPermissions(
        read=arguments.read, write=arguments.write, delete=arguments.delete, list=arguments.list
    )
    start = datetime.fromisoformat(arguments.start_date) if arguments.start_date else datetime.utcnow()
    expiry = datetime.fromisoformat(arguments.expiry_date)
    blob_service = BaseBlobService(account_name=arguments.account, account_key=account_key)
    sas = blob_service.generate_container_shared_access_signature(
        arguments.container, permission=perms, expiry=expiry, start=start
    )
    print(sas)
    sys.exit(0)
