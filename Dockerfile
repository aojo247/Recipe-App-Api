FROM python:3.9-alpine3.13

# Indicator of who is maintaining this project. Can be anything
LABEL maintainer="aojo247"

#recommended. Tells python that the output should not be buffered/delayed
ENV PYTHONUNBUFFERED 1

#copy file(s) from local project to docker image 
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

#specify the wroking directory where commands will be run from in the docker image
WORKDIR /app

#Expose port from container to your local machine
EXPOSE 8000

ARG DEV=false
#RUN will install dependencies on the machine. We are using \ and using only one RUN command to avoid multiple image layers being spun up
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

#defines the path where executables can be run
ENV PATH="/py/bin:$PATH"

#specifies the user who will run all commands. Root user will be used if not specified - We want to avoid doing that
USER django-user