FROM jupyter/tensorflow-notebook:2ce7c06a61a1


LABEL maintainer="Elias Youssef - https://github.com/nettoyoussef/science-reproducibility"

# Installing Mlflow
# Add Postgres SQL specific packages
RUN pip install mlflow==1.0.0 sqlalchemy==1.3.0 psycopg2-binary

#RUN mkdir -p /home/rstudio/experiments/

#Inicia um Mlflow Tracking Server na porta padrao - localhost:5000
EXPOSE 5000
CMD ["mlflow server', '--backend-store-uri /home/', '--host 0.0.0.0', '--port 5000']
