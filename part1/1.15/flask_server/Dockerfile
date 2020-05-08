FROM python:3.7


WORKDIR /mydir

COPY . .

RUN pip install -r requirements.txt

ENTRYPOINT ["python"]
CMD ["app.py"]
