# Python Script for Creating Networks in oVirt

This Python script uses the oVirt SDK to create networks in an oVirt environment. It connects to an oVirt engine, iterates over a dictionary of user context, and creates a network for each VLAN ID with the corresponding network name.

I wrote the script because we switched from another virtualization solution to oVirt and hundreds of already existing VLANs had to be created within oVirt. 

**Obviously this had to be automated ;-)**

## So please keep in mind that this is just a quick&dirty script which (ideally) should just save someone ,some time.

## Prerequisites

- Python 3.6 or later
- oVirt SDK for Python
- oVirt-Engine Web Certificate named `pki-resource.cer` in the working directory.

## Usage

1. Install the oVirt SDK for Python using pip:

`pip install ovirt-engine-sdk4`

2. Run the Python script:

`python create_networks.py`

## Docker

There is also a Dockerfile which can be built into a image by yourself. The purpose was to bypass a temporary python dependency issue on my system and to just have it working as quick as possible.

## Script Overview

The script begins by importing the oVirt SDK and defining the URL, username, and password for the oVirt engine. It also specifies the path to the certificate file for the connection.

```python
import ovirtsdk4 as sdk

# Define the URL, username, and password for the oVirt engine
URL = 'https://ovirt-engine.de/ovirt-engine/api'
USERNAME = 'admin@ovirt@internalsso'
PASSWORD = 'PASSWORD'

connection = sdk.Connection(
   url=URL,
   username=USERNAME,
   password=PASSWORD,
   ca_file='pki-resource.cer',
)
```

The script then defines a dictionary of user context, where each key-value pair represents a VLAN ID and a network name.

```python
user_context = {
    500: 'vlan-1',
    501: 'vlan-2',
    502: 'vlan-3'
}
```

The script iterates over the user context dictionary. For each VLAN ID and network name, it attempts to create a network in the oVirt environment. If the network creation is successful, it prints a success message. If it fails, it prints an error message.

```python
for vlan_tag, network_name in user_context.items():
 try:
    print(f'Creating network {network_name} with VLAN ID {vlan_tag}')
    network = sdk.types.Network(
        name=network_name,
        data_center=connection.system_service().data_centers_service().list()[0],
        vlan=sdk.types.Vlan(id=str(vlan_tag)),
        mtu=1500
    )
    connection.system_service().networks_service().add(network)
    print(f'Successfully created network {network_name}')
 except Exception as e:
    print(f'Failed to create network {network_name}: {e}')
```

Finally, the script closes the connection to the oVirt engine.

```python
connection.close()
```

## References

- [oVirt Python SDK](https://github.com/oVirt/python-ovirt-engine-sdk4)
- [oVirt Python SDK Guide](https://www.ovirt.org/documentation/doc-Python_SDK_Guide/)