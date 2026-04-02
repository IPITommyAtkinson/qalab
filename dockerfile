FROM python:3.11-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

ENV YOUR_NAME=Tommy

EXPOSE 5000

CMD ["python", "app.py"]
