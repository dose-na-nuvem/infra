## Infra

Nesse repositório encontram-se os arquivos utilizados para provisionar e gerenciar a infraestrutura utilizada no projeto dose na nuvem.

### Cluster Kubernetes Local

#### Requisitos

- [Docker](https://docs.docker.com/engine/install/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [Make](https://www.gnu.org/software/make/)
- [Helm](https://helm.sh/)

Para ajuda digite: 

`make help`

Saída do comando:

```shell
help              "Ajuda"
create-cluster    "Cria cluster Kubernetes Kind"
display-cluster   "Exibe cluster Kubernetes Kind"
delete-cluster    "Exclui cluster Kubernetes Kind"
install           "Instala os manifestos dos apps no cluster"
uninstall         "Remove os apps instalados no cluster"
```

helm update
helm install dose ./
