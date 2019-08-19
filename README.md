# Workshop sobre reprodutibilidade em Pesquisa Computacional - Unicamp (16/08)



**This repository contains files used for a workshop at Unicamp (Brasil) about reproducibility in Computational Research.**



A questão sobre a reprodutibilidade na ciência tem sido considerada um problema importante e endêmico entre pesquisadores modernos. Segundo pesquisa feita pela [Nature](https://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970) em 2016 com 1500 cientistas, 70% dos entrevistados foram incapazes de replicar experimentos de outros grupos de pesquisa, e mais da metade foi incapaz de reproduzir seus próprios resultados.

Esse é um problema que afeta o cerne do método científico, já que impede a validação de teorias de forma independente e, com isso, adultera o processo de criação de consensos. 

Para as áreas baseadas no empirismo, a incapacidade de replicar análises dá margem para que fatores como interesses econômicos, viéses pessoais ou status influenciem o processo de transformação de pesquisa em conhecimento científico.

O intuito desse Workshop será mostrar ferramentas que permitem a reprodutibilidade de pesquisa computacional e análises sobre dados já coletados ou abertos. Particularmente para as áreas de ciência da computação e ciências sociais, o teste de hipóteses sobre dados secundários e a comparação de novos algorítmos constitui uma área fundamental da pesquisa.

Entre os tópicos tratados teremos:

* Quais são os conceitos necessários para a reprodução da pesquisa computacional
* Versionamento para ambiente, bibliotecas, código, dados e experimentos
* Ferramentas mais utilizadas (docker, conda, git, DVC, Mlflow, Drake entre outras)

O workshop será dividido em duas etapas:
* uma apresentação de meia hora com os conceitos principais
* uma parte aplicada com uma introdução desses paradigmas nas linguagens R e Python, com duração prevista de meia hora. Nessa parte, teremos a reprodução de um experimento.

Para os interessados na parte aplicada, será necessário:
* trazer seu próprio notebook
* ter acesso à internet nas dependências da FEEC
* seguir as instruções da página abaixo antes do workshop

https://github.com/nettoyoussef/science-reproducibility

As instruções serão atualizadas nessa página até o dia 14/08 (quarta-feira). Nela, constarão um passo a passo da instalação dos programas e códigos necessários para reprodução do experimento que será tratado. É bastante importante que os programas sejam instalados com antecedência visto que não haverá tempo hábil para realizar essa etapa durante o workshop.


## Requerimentos para parte prática - (atualizado 14/08/2019)

- Sistema operacional Linux (é possível rodar Docker e Git em Windows/MAC OS, entretanto o tutorial para essas plataformas foge do escopo do Workshop).
- Caso seu sistema operacional não seja Linux, você talvez ainda consiga acompanhar o workshop se já tiver experiência com powershell e git.
- Instalar a versão estável mais recente do [Docker](https://docs.docker.com/install/) para sua plataforma.
- Instalar a versão estável mais recente do [Docker-compose](https://docs.docker.com/compose/install/) para sua plataforma.
- Instalar a versão estável mais recente do [git](https://git-scm.com/downloads) para sua plataforma.
- Caso você queira rodar análises com sua placa de vídeo, instale [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) (não é necessário para o workshop).
- Ter pelo menos 15 gb de espaco livre no seu diretorio principal (root). Usualmente se requer menos, mas como trabalharemos com imagens de propósito multiuso, será necessário mais espaço.
- Seguir as outras instruções abaixo

## Passos para rodar o experimento (ver mais detalhes abaixo)
1. Baixar uma cópia desse repositório para o diretório em que voce quer rodar o experimento.
2. Atualizar caminhos dos diretórios no arquivo `./Dockerfiles/.env`
3. Montar e subir imagens.
4. Checar se imagens estão acessíveis no seu browser de preferência
5. Rodar os experimentos

### 1. - Cópia do repositório

Caso você já tenha instalado o git de forma bem-sucedida, você pode copiar este repositório direto da sua linha de comando. Basta escolher um diretório onde você quer salvar o projeto e digitar:

```Shell
$ cd caminho/diretorio/
$ git clone https://github.com/nettoyoussef/science-reproducibility
```

Este comando irá criar um novo diretório chamado `science-reproducibility` dentro da pasta escolhida. É possível checar se sua cópia confere com a versão da página fazendo:

```Shell
$ cd caminho/diretorio/science-reproducibility
$ git status
```

Se tudo estiver correto aparecerá a mensagem:

```
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```

Caso você não tenha instalado o git, é possível baixar uma versão zip do repositório clicando em `clone or download` no ícone verde na parte superior direita da página.


### 2. Atualizar caminhos dos diretórios no arquivo `./Dockerfiles/.env`

Uma vez na pasta do repositório, abra o arquivo `.env` na pasta `science-reproducibility/Dockerfiles/`. Caso você não veja o arquivo, clique em exibir pastas e arquivos ocultos no seu gerenciador de janelas.

Dentro desse arquivo, voce verá:

```
#Project Directory
PROJECT_DIR=/home/.../path/to/science-reproducibility/

#Usuario - para logins
LOGIN_USER=science-repro

#Senha para acesso ao Jupyter Notebook
JUPYTER_PASSWORD=science-repro-senha

#Senha para acesso ao Rstudio
RSTUDIO_PWD=science-repro-senha
```

Atualize os caminho do arquivo para a pasta escolhida, incluindo `science-reproducibility`. Salve às alterações. Mantenha as senhas de usuário por hora.


### 3. Montar imagens.


Para montar as imagens contidas nas dockerfiles, abra sua linha de comando e digite:

```Shell
$ cd caminho/diretorio/science-reproducibility/Dockerfiles
$ docker-compose config
```

Analise a saída. As variáveis de ambiente devem aparecer como abaixo (note que os ... representam informação omitida):

```
 ...
  mlflow_tracker:
    build:
        ...
    environment:
      JUPYTER_PASSWORD: science-repro-senha
      LOGIN_USER: science-repro
      PROJECT_DIR: caminho/diretorio/science-reproducibility
      RSTUDIO_PWD: science-repro-senha
        ....
    volumes:
    - caminho/diretorio/science-reproducibility/experiments:/home/science-repro/experiments:rw
  python:
    ...
    environment:
      JUPYTER_PASSWORD: science-repro-senha
      JUPYTER_TOKEN: science-repro-senha
      LOGIN_USER: science-repro
      PROJECT_DIR: caminho/diretorio/science-reproducibility
      RSTUDIO_PWD: science-repro-senha
    ...
    volumes:
    - caminho/diretorio/science-reproducibility:/home/science-repro:rw
  r:
    build:
      args:
        PASSWORD: science-repro-senha
        USER: science-repro
      ...
    environment:
      JUPYTER_PASSWORD: science-repro-senha
      LOGIN_USER: science-repro
      PROJECT_DIR: caminho/diretorio/science-reproducibility
      RSTUDIO_PWD: science-repro-senha
    ...
    volumes:
    - caminho/diretorio/science-reproducibility:/home/science-repro:rw
 ...   
```

Confira se os caminhos estão atualizados para o seu diretório, e se as senhas constam como no arquivo `.env`.
Se tudo estiver correto, execute:

```Shell
$ docker-compose build --no-cache
```

Este comando irá baixar e construir as imagens necessárias para construção desse experimento.  


Aproveite para relaxar e fazer um café, pois esta etapa irá demorar vários minutos (~ 28 minutos na minha máquina). Caso voce encontre problemas durante a execução, cancele a geração da imagem (`Ctrl+C`) e tente novamente com o cache:

```Shell
$ docker-compose build
```

### 4. Checar imagens.

Se tudo rodar sem erros, voce pode subir as imagens com o comando:

```Shell
$ docker-compose up
```

Este último comando irá criar três containers contendo diferentes aplicações para R e Python.
Eles estarão acessíveis no seu caminho local nas portas 8787, 8888 e 5000.

```
http://127.0.0.1:8787
ou
http://localhost:8787/
e etc
```

Acesse os containers digitando esse caminho no seu browser de preferência (Firefox, Chrome etc).
Para ver os containers criados digite na sua linha de comando:

```Shell
$ sudo docker ps -a
```

Para ver as imagens criadas, sua data e tamanho:

```Shell
$ sudo docker images
```

### 5. Rodar os experimentos

Dentro da pasta `Code` constam três experimentos. O primeiro, chamado de [python_example_1.py](https://machinelearningmastery.com/machine-learning-in-python-step-by-step/) visa demonstrar como é o desenvolvimento dentro de um container. Ao rodá-lo dentro da IDE do Rstudio, caso você esteja com acesso a internet, várias figuras serão geradas usando o famoso banco de dados Íris.  

O segundo experimento, dentro da pasta python_mlflow, representa o versionamento de um experimento usando Python e [Mlflow](https://mlflow.org/). O código usa o banco de dados `wine-quality` contido na pasta `Data`.
Ao rodar o [experimento](https://github.com/mlflow/mlflow/tree/master/examples/sklearn_elasticnet_wine), métricas e parâmetros de um classificador serão armazenadas na pasta `Experiments` (atenção, se você mudou o nome de usuário, atualize o caminho da URI de tracking no código com o novo nome), juntamente com um arquivo pkl contendo o modelo. Para visualizá-los na URI do Mlflow, basta ir até `localhost:5000` e atualizar a página.

O terceiro experimento é feito na linguagem R e demonstra o uso de DAGs e cache usando o framework [Drake](https://ropenscilabs.github.io/drake-manual/). O código `make.R` cria um cache, carrega funções, banco de dados e plano de trabalho que, após ser executado, tem como saída um reporte na pasta `Reports`. Para visualizar o DAG gerado, retire o `#` da linha 26 e rode o código de forma iterativa (numa sessão do Rstudio, p.e.). Isso gerará um gráfico de dependências do código.











