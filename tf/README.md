# deub terraform 

## Requirements 

Terraform module for a cloud provider of your choice which (The free tier should be sufficient for such a simple case.):

- creates a managed instance group of VMs

- each VM is serving a Docker image (choose any, for instance https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-hello) that listens for connections on some port

- creates a load balancer with managed instance group as backend that load balances incoming HTTP calls to it

## Notes on implementation

- Cloud provider: AWS

- The "managed instance group" is implemented as autoscaling group, 
  -- min 2 and max 4 VMs.
  -- health is checked by GET to / and expect 200

- Fully encapsulated, i.e. it includes all components, ground-up.

- Each component is usually in different TF script, some are howerver grouped.

- Most attributes are set as variables, and given values in per-stage values-* file.

- Staging is covered with workspaces.  

- For simplicity, no special care has been taken for security and TCP/443 has no certificate.

- The multiple components have been defined statically for simplicity. E.g.: 

```
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.0.0/23"
  ...
```

instead of 

```
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.${count.index * 2}.0/23"
}
```

## Usage

### Preparation

First thing is to created the workspaces: 

```
$ terraform init
$ terraform workspace new prod
$ terraform workspace new dev
```

### Single run for all

The `main.tf` includes a call to all necessary modules for a whole system to start from scrathc till running. For it to run for _`dev`_ environment (similar for _`prod`_): 

```
$ terraform workspace select dev
$ terraform plan --var-file=dev.tfvars -out=dev.plan
$ terraform apply dev.plan
```

The `main.tf` will do these steps: 

- First step, the AMI is created. The autoscaling group will use that AMI, which includes Linux, Docker and other tools, and the nginx docker image.<br>
For any change, that image should be recreated and the variable `ami_id` should be updated.

- After the AMI exists and the ID is set to `ami_id`, then use the usual `terraform plan` to make it run and create the infrastructure. But first choose stage: 


The scripts are kind-of encapsulating everything, meaning it does not expect anything to be there. It creates the whole ecosystem ground-up, from the VPC up to the running instance in autoscale group.

### Updates

For any new AMI, like different workload or newer Linux image or libraries, one must re-run the AMI and manually update the launch-template with the new ID.

## Caveats

Due to technical problems and illness, it has not been tested against AWS.
