# Prove of Concept - Storage S3 + Terraform
Aplicação para armazenamento de mídias na AWS utilizando o serviço S3,Spring e Terraform como IaS.


## Arquitetura 
![Imagem Upload realizado com Sucesso](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/devops-aws/app-storage-aws-arch.png)


## Tecnologias 
- Java 11
- Spring MVC 
- Thymeleaf
- Terraform
- AWS S3, IAM
- VPC: Security Groups, Application Load Balancer , Subnets, NAT Gateway, Elastic IP , Internet Gateway
 - Simple Storage Service (S3)
 - Cloud Watch
 - Github como Source Provider
 - Code Build
 - Code Deploy com Blue/Green Deployment
 - Code Pipeline
 - Elastic Container Service (ECS) com Fargate
 - Auto Scale
 - Elastic Container Registry (ECR) para armazenamento de imagens docker


## Exemplo aplicação
	
1 - Upload
Abaixo é mostrado o envio de um novo arquivo.
![Imagem Upload realizado com Sucesso](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/app-storage-success-upload.png)

2 - Caixa de Download
Abaixo é mostrado a caixa de download após clicar no botão "Download".
![Imagem Download](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/app-storage-download.png)

3 - Evidência upload
Abaixo é mostrado os objetos salvos no bucket s3 criado na pasta /upload;
![Imagem Download](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/objects-bucket.png)



## Infraestutura como Código (IaC) - Terraform

Para o presente projeto foi utilizado o Terraform para a construção dos recursos **S3**,**IAM (User,  Policy , Secrets**).

### Requisitos para executar o Terraform
 Configurar/Criar  o arquivo de credentiais de perfil  no caminho padrão *`~/.aws/credentiais`* informando as suas chaves geradas no console da AWS. No exemplo a seguir é mostrado como ficam as credenciais para cada ambiente presente na pasta *`terraform/env*.

```bash
[test]
aws_access_key_id=[YOUR_TEST_ACCESS]
aws_secret_access_key=[YOUR_TEST_SECRET]
[localstack]
aws_access_key_id=[YOUR_LOCAL_ACCESS]
aws_secret_access_key=[YOUR_LOCAL_SECRET]
[hom]
aws_access_key_id=[YOUR_HOM_ACCESS]
aws_secret_access_key=[YOUR_HOM_SECRET]
[prod]
aws_access_key_id=[YOUR_PROD_ACCESS]
aws_secret_access_key=[YOUR_PROD_SECRET]
.
.

```
IMPORTANTE: Para rodar utilizando o ambiente localstack é necessário configurar os endpoints dos serviço no provider, conforme mostrado https://docs.localstack.cloud/integrations/terraform.
### Executando Terraform
 Inicie o terraform:
 
```bash
 terraform init
```
 Aplique  a criação dos recursos para o ambiente que deseja. Os valores de [ENV] são **test**,**localstack**,**hom**,**prod**.
 
```bash
cd ./terraform
./start.sh [ENV]
 ```


#### Apenas se estiver executando a aplicação local
Após o fim da execução do script será gerado as credenciais que serão utilizadas para conectar a aplicação com o serviço de S3. O Arquivo de credenciais fica: 	

```bash
[test]
aws_access_key_id=[YOUR_ACCESS]
aws_secret_access_key=[YOUR_SECRET]
.
.
.
.
[test-app-storage]
aws_access_key_id=[ACCESS_USER_APP_STORAGE]
aws_secret_access_key=[SECRET_USER_APP_STORAGE]
 ```
 
### Destruindo os recursos criados
```bash
cd ./terraform
./start.sh [ENV]
 ```


## Esteira CI/CD utilizando recursos na AWS

### FLuxo geral
1- Obtendo código fonte armazenado no Github
![Source Provider](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/devops-aws/source-success.png)

2- Construindo a imagem docker para a aplicação 
![Source Provider](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/devops-aws/code-build-success.png)

3- Deploy da aplicação utilizando ECS com Blue/Green Deployment
![Source Provider](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/devops-aws/code-deploy-success.png)

### Acessando aplicação via DNS do load balancer
![Source Provider](https://github.com/maiconsa/app-storage-aws-s3-terrafom/blob/main/images/devops-aws/code-deploy-success.png)

