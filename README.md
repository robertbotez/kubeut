# KubeUT: A Cloud-Agnostic Kubernetes Management Tool
KubeUT is designed to simplify the process of deploying Kubernetes clusters on different cloud environments, including OpenStack, vSphere, and bare-metal infrastructure. With its cloud-agnostic approach, it allows users to deploy and manage Kubernetes clusters consistently across multiple cloud platforms. By leveraging the power of Terraform, KubeUT automates the provisioning of cluster nodes, making it easy to scale up or down as needed. The tool also utilizes Ansible to streamline cluster creation, enable addons, or scale the worker nodes.

## Description
KubeUT provides a solution for automating the deployment of Kubernetes clusters in the CloudUT infrastructure (https://cloudut.utcluj.ro/en/). It simplifies the process and reduces complexity for users. The service includes a component for creating Kubernetes nodes, which is compatible with multiple cloud providers.

Supported and implemented functionalities include:

- Kubernetes versions 1.22+
- Kubernetes HA cluster
- KubeUT CLI
- KubeUT Dashboard
- Provisioning of virtual machines (Kubernetes nodes) in cloud infrastructures:
  - vSphere
  - OpenStack
- Scaling worker nodes
- Plugins:
  - Kubernetes dashboard
  - Helm
  - GPU support
  - Nginx Ingress Controller
  - Monitoring – Prometheus + Grafana
  - OpenFaas
- Container Runtimes:
  - Docker
  - NVIDIA-Docker (requires CUDA and NVIDIA drivers to be installed on worker nodes)
- Supported OS:
  - Ubuntu 18+
  - Debian 9+
  - CentOS/RHEL 7+
  - Fedora 35+

## Usage

1. Clone the KubeUT repository to your desired location, such as your home directory:

   ```bash
   git clone https://github.com/robertbotez/kubeut.git
   
 2. Install Ansible, Terraform, and crudini on your system. You can follow the official documentation for each tool to install them correctly.
 3. Export the following environment variables in your terminal (Make sure to replace $HOME/kubeut with the actual path where you cloned the KubeUT repository):
    ```bash
    export PATH=$PATH:$HOME/kubeut/bin
    export KUBEUT=$HOME/kubeut/bin
 4. Before using the KubeUT CLI app, you need to configure the necessary files for infrastructure provisioning and deployment. Follow these steps:
  - Open the `vars/main.yaml` file in the cloned KubeUT repository.
    - Customize the variables according to your infrastructure requirements, such as network settings, VM sizes, and cluster configurations. Make sure to review and modify the values as needed.
  - Open the `inventory.yml` file in the cloned KubeUT repository.
    - Specify the target hosts for the deployment, including IP addresses or hostnames.
  - Customize the Terraform files (`*.tf`) in the cloned KubeUT repository.
    - Modify the Terraform files to match your desired infrastructure provisioning settings. Update the resource definitions, network configurations, and any other specific requirements.  
  
  Please note that these configuration steps are required only if you are using the CLI app. For the web application, the user can customize the infrastructure and deployment by filling a form provided by the application.
  
 5. You can now use the KubeUT CLI app to manage your Kubernetes clusters. For example:
   - To create the necessary resources for the cluster on OpenStack:
  ```bash
    kubeut provision --openstack
  ```
   - To deploy the cluster on the provisioned resources:
  ```bash
    kubeut deploy
  ```
   - To deploy Prometheus and Grafana for the cluster:
  ```bash
    kubeut enable monitoring
  ```
  - For more detailed information on available commands and options, use help:
  ```bash
    kubeut help
  ```
## Roadmap
The repository will be updated in the next period with the web application of this tool.

## Auhtor
Copyright © Robert BOTEZ: robert.botez1996@gmail.com / Robert.Botez@com.utcluj.ro
