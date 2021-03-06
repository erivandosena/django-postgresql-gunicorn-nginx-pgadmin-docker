# Versao do Python
FROM python:3.7

LABEL maintainer=erivandosena@gmail.com

# Cria link simbolico
RUN ln -sf config/env/env_django .env

# Define variaveis de ambiente
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ARG DOCKER_SERVICE_NAME
ENV PROJECT_DIR /opt/services/${DOCKER_SERVICE_NAME}/src

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

# Define comandos para execucao ao iniciar o conteiner
CMD ["sh", "-c", "python3 manage.py collectstatic --no-input; python3 manage.py migrate; python3 manage.py createsuperuser --no-input; gunicorn --chdir appweb --bind :8000 appweb.wsgi:application"]