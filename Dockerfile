FROM python:3.12-alpine3.18

ENV FLASK_APP=app.py \
    FLASK_ENV=development

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ /app

WORKDIR /app

ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]