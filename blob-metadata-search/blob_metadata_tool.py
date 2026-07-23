#!/usr/bin/env python3
"""
blob_metadata_tool.py
=====================
Query Azure Blob custom metadata (x-ms-meta-*) using the data-plane SDK.

Two modes:
  1) list   -> list all custom metadata on a given blob
  2) search -> scan a container and return blob(s) that carry a given metadata
               key (and optional value). This is a CLIENT-SIDE search:
               metadata is NOT server-indexed, so the tool enumerates blobs
               and filters locally. Fine for small/medium containers; O(all blobs).

AUTH (in priority order):
  - --account-key <key>            explicit key
  - AZURE_STORAGE_KEY env var      account key
  - AZURE_STORAGE_CONNECTION_STRING env var
  - Azure AD (DefaultAzureCredential) if none of the above is set
        (requires the "Storage Blob Data Reader" role on the account)

INSTALL:
  pip install azure-storage-blob azure-identity

EXAMPLES:
  # 1) List all metadata on a blob
  python blob_metadata_tool.py list --account savonblobsearch01 --container blob-search-demo --blob Hello_world.txt

  # 2) Search a container for blobs where metadata key "author" exists
  python blob_metadata_tool.py search --account savonblobsearch01 --container blob-search-demo --key author

  # 2b) Search where key "author" == "guillaume" (value match, case-insensitive keys)
  python blob_metadata_tool.py search --account savonblobsearch01 --container blob-search-demo --key author --value guillaume
"""

import argparse
import os
import sys

try:
    from azure.storage.blob import BlobServiceClient
except ImportError:
    sys.exit("Missing dependency. Run: pip install azure-storage-blob azure-identity")


def build_service_client(account: str, account_key: str | None) -> "BlobServiceClient":
    """Create a BlobServiceClient using the best available auth method."""
    conn = os.environ.get("AZURE_STORAGE_CONNECTION_STRING")
    if conn:
        return BlobServiceClient.from_connection_string(conn)

    key = account_key or os.environ.get("AZURE_STORAGE_KEY")
    account_url = f"https://{account}.blob.core.windows.net"
    if key:
        return BlobServiceClient(account_url, credential=key)

    # Fall back to Azure AD (needs "Storage Blob Data Reader" or higher).
    try:
        from azure.identity import DefaultAzureCredential
    except ImportError:
        sys.exit(
            "No key/connection string provided and azure-identity is not installed.\n"
            "Either pass --account-key, set AZURE_STORAGE_KEY, or run: pip install azure-identity"
        )
    return BlobServiceClient(account_url, credential=DefaultAzureCredential())


def cmd_list(args) -> int:
    """List all custom metadata (x-ms-meta-*) on a single blob."""
    svc = build_service_client(args.account, args.account_key)
    blob_client = svc.get_blob_client(args.container, args.blob)
    props = blob_client.get_blob_properties()
    metadata = props.metadata or {}

    blob_id = f"{args.container}/{args.blob}"
    print(f"Blob: {blob_id}")
    print(f"URL:  {blob_client.url}")
    if not metadata:
        print("Metadata: (none)")
        return 0

    print("Metadata (custom x-ms-meta-*):")
    for k, v in sorted(metadata.items()):
        print(f"  {k} = {v}")
    return 0


def cmd_search(args) -> int:
    """
    Client-side search across a container: return blob IDs whose custom metadata
    contains the given key (optionally matching a given value).
    """
    svc = build_service_client(args.account, args.account_key)
    container_client = svc.get_container_client(args.container)

    target_key = args.key.lower()  # metadata keys are case-insensitive / lowercased
    target_value = args.value

    matches = []
    scanned = 0
    # include=["metadata"] returns metadata inline -> avoids a per-blob round-trip,
    # but still enumerates the WHOLE container (O(all blobs)).
    for blob in container_client.list_blobs(include=["metadata"]):
        scanned += 1
        meta = {k.lower(): v for k, v in (blob.metadata or {}).items()}
        if target_key in meta:
            if target_value is None or meta[target_key] == target_value:
                blob_id = f"{args.container}/{blob.name}"
                matches.append((blob_id, meta[target_key]))

    print(f"Scanned {scanned} blob(s) in container '{args.container}'.")
    if not matches:
        crit = f"key='{args.key}'" + (f", value='{target_value}'" if target_value else "")
        print(f"No blobs found with metadata {crit}.")
        return 1

    print(f"Found {len(matches)} matching blob(s):")
    for blob_id, val in matches:
        print(f"  BLOB ID: {blob_id}    ({args.key} = {val})")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Query Azure Blob custom metadata (x-ms-meta-*) via the data-plane SDK."
    )
    sub = parser.add_subparsers(dest="command", required=True)

    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--account", required=True, help="Storage account name")
    common.add_argument("--container", required=True, help="Container name")
    common.add_argument("--account-key", default=None,
                        help="Account key (else AZURE_STORAGE_KEY / connection string / Azure AD)")

    p_list = sub.add_parser("list", parents=[common],
                            help="List all metadata on a given blob")
    p_list.add_argument("--blob", required=True, help="Blob name")
    p_list.set_defaults(func=cmd_list)

    p_search = sub.add_parser("search", parents=[common],
                              help="Search container for a blob carrying a given metadata key")
    p_search.add_argument("--key", required=True, help="Metadata key to search for")
    p_search.add_argument("--value", default=None,
                          help="Optional metadata value to match exactly")
    p_search.set_defaults(func=cmd_search)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
