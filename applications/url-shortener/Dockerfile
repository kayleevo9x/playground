ARG BUILD_IMAGE=python:3.12-slim
ARG CODE_DIR="/app"

FROM ${BUILD_IMAGE} as build
EXPOSE 8000

ARG CODE_DIR
ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=1 \
    POETRY_VERSION=1.8.3

WORKDIR ${CODE_DIR}

COPY . .
RUN pip install --upgrade pip poetry
RUN pip install uvicorn 
RUN poetry build

FROM build as dev
ARG CODE_DIR
WORKDIR ${CODE_DIR}
COPY --from=build ${CODE_DIR} ${CODE_DIR}
RUN poetry install
CMD ["uvicorn", "url_shortener.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload","--log-level", "debug"]

FROM build as main
ARG CODE_DIR
WORKDIR ${CODE_DIR}
COPY --from=build ${CODE_DIR} ${CODE_DIR}
RUN poetry install
CMD ["uvicorn", "url_shortener.main:app", "--host", "0.0.0.0", "--port", "8000"]