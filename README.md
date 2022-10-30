# CET-005

### Architecture:

![Architecture](https://github.com/mohamed-farag88/CET-005/blob/main/CET-005.jpeg)

## CloudFormation Templates

We have two CloudFormation templates that creates the following resources:

- VPC CFN
    - Resources [network.yaml]:
        - VPC.
        - 2 public subnets in 2 different Availability Zones.
        - 2 private subnets in 2 different Availability Zones.
        - Internet Gateway.
        - Route Tables and Routes.
        - Network Access Control List.
        - NAT Gateway.
    - Parameters [network_parameters.json]:
        - VPC CIDR.
        - Subnets CIDRs.

- Servers CFN
    - Resources [server.yaml]:
        - Bastion host.
        - Web instance in every subnet.
        - Bastion security group (allow ssh from specific IP).
        - Public Instance security group (allow 80 from everywhere, 22 from VPC CIDR).
        - Private Instance security group (allow 80, 22 from VPC CIDR).
        - NAT Gateway.
    - Parameters [server_parameters.json]:
        - Key name.
        - Bastion allowed IP.
        - Instances types.



> Both CFN templates and can performthe following scenarios:
>  1. SSH to Bastion host.
>  2. Access public Web servers from browsers using public IP.
>  3. Access private Web servers from the bastion host.
>  4. SSH public and private servers using bastion as a tunnel.

## Parameters:

For [network_parameters.json], and [server_parameters.json] we have the below parameters:

>Modify the valus inside parameters json files to suite your deployment

| Parameter Name | Description | Type | Value |
| ------ | ------ | ------ | ------ |
| EnvironmentName | An environment name that will be prefixed to resource names | String | cet005 |
| VpcCIDR | IP range (CIDR notation) for this VPC | String | 10.40.0.0/16 |
| PublicSubnet1CIDR | IP range (CIDR notation) for the public subnet in the first Availability Zone | String | 10.40.1.0/24 |
| PublicSubnet2CIDR | IP range (CIDR notation) for the public subnet in the second Availability Zone | String | 10.40.2.0/24 |
| PrivateSubnet1CIDR | IP range (CIDR notation) for the private subnet in the first Availability Zone | String | 10.40.10.0/24 |
| PrivateSubnet2CIDR | IP range (CIDR notation) for the private subnet in the second Availability Zone | String | 10.40.20.0/24 |
| InstanceType | EC2 Instance Type | String | t2.micro |
| LatestAmiId | Get the latest Image ID |  |  |
| SSHKeypair | Amazon EC2 Key Pair |  |  |
| BastionHostIP | Bastion allowed IP | String |  |



## [Scripts]

### To craete stack use [create_stack] shell script as shown:

```sh
./scripts/create_stack.sh <Stack_name> <Stack YAML File> <Stack Parameters Json File>

Example:

./scripts/create_stack.sh serversstack server.yaml server_parameters.json
```
### To update stack use [update_stack] shell script as shown:

```sh
./scripts/update_stack.sh <Stack_name> <Stack YAML File> <Stack Parameters Json File>

Example:

./scripts/update_stack.sh serversstack server.yaml server_parameters.json
```


### To delete stack use [delete_stack] shell script as shown:

```sh
./scripts/delete_stack.sh <Stack_name>

Example:

./scripts/delete_stack.sh serversstack
```


## Access servers from the bastion host

1- Download you pem file.

2- Set ssh config file as shown below:

        vi ~/.ssh/config
        Host bastionhost
            Hostname (EC2 Public IPv4 DNS or Public IPv4 address) 
            User ec2-user
            IdentityFile  ~/path/to/the/myfile.pem
        Host 10.40.*
            IdentityFile  ~/path/to/the/myfile.pem
            User ec2-user
            ProxyCommand ssh -W %h:%p  ec2-user@bastionhost


>ProxyCommand ssh -W %h %p : Specifies the command to use to connect to the server forwarded.In this example, Any occurrence of %h will be substituted by the host name to connect, %p by the port.

>Your Laptop then connects through the (-W )tunnel and reaches the target server

>The ProxyCommand then tells the system to first ssh to our bastion host and open a connection to host %h (hostname supplied to ssh) on port %p (port supplied to ssh).

>To make generic for all hosts in private subnet we set the second block to all subnets "10.40.*"

3- SSH to Bastion host

    ssh bastionhost

4- SSH to Server hosts

    ssh <server private IP>
    EX.
    ssh 10.40.10.121

>The ProxyCommand then tells the system to first ssh to our bastion host and open a connection to host %h (hostname supplied to ssh) on port %p (port supplied to ssh).







   [network.yaml]: <https://github.com/mohamed-farag88/CET-005/blob/main/network.yaml>

   [network_parameters.json]: <https://github.com/mohamed-farag88/CET-005/blob/main/network_parameters.json>

   [server.yaml]: <https://github.com/mohamed-farag88/CET-005/blob/main/server.yaml>

   [server_parameters.json]: <https://github.com/mohamed-farag88/CET-005/blob/main/server_parameters.json>

   [Scripts]: <https://github.com/mohamed-farag88/CET-005/tree/main/scripts>

   [create_stack]: <https://github.com/mohamed-farag88/CET-005/blob/main/scripts/create_stack.sh>

   [update_stack]: <https://github.com/mohamed-farag88/CET-005/blob/main/scripts/delete_stack.sh>

   [delete_stack]: <https://github.com/mohamed-farag88/CET-005/blob/main/scripts/update_stack.sh>

