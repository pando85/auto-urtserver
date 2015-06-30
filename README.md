# automatic-urbanterror-server
Script to create an Urban Terror server using docker.

# Usage

## Build docker images
```bash
sudo bash auto-urtservers.sh install
```

## Create new server
```bash
sudo bash auto-urtservers.sh init <server-name> <port>
```

## Remove server
```bash
sudo bash auto-urtservers.sh remove <server-name>
```

## Install new maps
To install new maps just copy them inside ```conf/maps``` directory.