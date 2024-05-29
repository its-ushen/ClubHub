FROM python:3.10-slim

# sets the working directory
WORKDIR /app

# copy the requirements
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app /app
CMD ["flask", "run", "--host=0.0.0.0"]