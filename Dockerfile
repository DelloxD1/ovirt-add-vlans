FROM python:3

WORKDIR /usr/src/app

COPY ovirt_create_vlans.py ./
COPY pki-resource.cer ./

RUN pip install ovirt-engine-sdk-python

CMD [ "python", "./ovirt_create_vlans.py" ]