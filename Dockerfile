# Created with reference to https://qiita.com/kandalog/items/bdb4c018c3971a150321
FROM python:3.11.4-alpine

ENV POETRY_VIRTUALENVS_CREATE=false
ENV PATH=/app/src:$POETRY_HOME/bin:$PATH

WORKDIR /app

COPY pyproject.toml poetry.lock /app/
COPY src/createuser.sh /usr/bin/createuser.sh

RUN apk --update add su-exec curl bash poetry && \
	chmod +x /usr/bin/createuser.sh && \
	poetry install --without dev

ENTRYPOINT ["/usr/bin/createuser.sh"]

# NOTE: コンテナはワンショットで実行されれば十分なので、CMDは不要
#       usageを表示して終了しても良いかもしれない
