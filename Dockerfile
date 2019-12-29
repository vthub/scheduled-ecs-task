FROM python:3
RUN pip install requests
WORKDIR /app
ADD index.py /app/
CMD [ "python", "/app/index.py" ]
