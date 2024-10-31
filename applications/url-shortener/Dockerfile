ARG CODE_DIR="/app"

FROM python:3.12-alpine AS build

ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=1 \
    POETRY_VERSION=1.8.3
EXPOSE 8000
ARG CODE_DIR

RUN apk add --no-cache py3-pip bash && \
    pip install --upgrade --no-cache pip && \
    apk add --no-cache --virtual .build-deps python3-dev && \
    pip install --upgrade poetry uvicorn && \
    apk del .build-deps

WORKDIR ${CODE_DIR}

COPY . .
RUN poetry build

FROM build AS dev
ARG CODE_DIR
WORKDIR ${CODE_DIR}
COPY --from=build ${CODE_DIR} ${CODE_DIR}
RUN poetry install
ENTRYPOINT ["./entrypoint.sh"]
CMD ["api-debug"]

FROM build AS test
ARG CODE_DIR
WORKDIR ${CODE_DIR}
COPY --from=build ${CODE_DIR} ${CODE_DIR}
RUN poetry install --with test
ENTRYPOINT ["./entrypoint.sh"]
CMD ["api-test"]

FROM build AS main
ARG CODE_DIR
WORKDIR ${CODE_DIR}
COPY --from=build ${CODE_DIR} ${CODE_DIR}
RUN poetry install
ENTRYPOINT ["./entrypoint.sh"]
CMD ["api"]