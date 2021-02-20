FROM ubuntu:14.04
LABEL Oraclize = "info@Oraclize.it"

RUN apt-get update && apt-get -y install python -minimal
CMD /usr/bin/python -c "import random; print random.randint(0, 50)"