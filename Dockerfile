# Versao do Python
FROM python:3.7

LABEL maintainer=erivandosena@gmail.com

# Cria link simbolico para .env
RUN ln -sf config/env/env_django .env

# Define variaveis de ambiente
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ARG PROJ_APP_NAME
ENV PROJECT_DIR /opt/services/${PROJ_APP_NAME}/src

# Cria caminho da aplicacao
RUN mkdir -p ${PROJECT_DIR}

# Define diretorio de trabalho do conteiner
WORKDIR ${PROJECT_DIR}

# Copia projeto
COPY . ${PROJECT_DIR}

# Instala dependencias
RUN pip3 install pipenv
RUN pipenv lock
RUN pipenv install --system
RUN pip3 uninstall --yes pipenv

# Servico Django
EXPOSE 8000

# Define comando padrao para execucao ao iniciar o conteiner
CMD ["python3", "manage.py", "runserver", "0:8000"]