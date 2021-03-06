env = "test"
app_name = "app-storage"

vpc_cidr="10.1.0.0/16"
availability_zones=["us-east-1a","us-east-1b"]
public_subnet_cidrs=["10.1.1.0/24","10.1.2.0/24"]
private_subnet_cidrs=["10.1.20.0/24","10.1.30.0/24"]
github_repository_url="https://github.com/maiconsa/app-storage-aws-s3-terrafom"

healthcheck_path="/actuator/health"


container_name="app-storage"
container_image="app-storage"
container_port=8080
container_cpu=256
container_memory=512

repository_id="maiconsa/app-storage-aws-s3-terrafom"
branch_name="feature/devops-aws"

autoscale_max=2
autoscale_min=1
autoscale_mem_value=80
autoscale_cpu_value=80