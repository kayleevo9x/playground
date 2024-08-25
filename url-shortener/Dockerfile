ARG BUILD_IMAGE=python:3.12-slim
ARG CODE_DIR="/app"

FROM ${BUILD_IMAGE} as build
EXPOSE 8000

ARG CODE_DIR
ARG UID=1000
ARG GID=1000
ARG CODE_DIR
RUN addgroup --force-badname --gid ${GID} usergroup
RUN adduser --force-badname --disabled-password --gecos '' --uid ${UID} --gid ${GID} user

RUN mkdir ${CODE_DIR}
RUN chown -R ${UID}:${GID} ${CODE_DIR}

WORKDIR ${CODE_DIR}

COPY . .
RUN chown -R ${UID}:${GID} *

USER ${UID}:${GID}
RUN pip install --upgrade pip poetry==1.8.3
RUN poetry config virtualenvs.create false
RUN poetry build

FROM build as dev
ARG CODE_DIR
WORKDIR ${CODE_DIR}

COPY --from=build ${CODE_DIR} ${CODE_DIR}
RUN pip install uvicorn 
RUN poetry install
CMD ["uvicorn", "url_shortener.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload","--log-level", "debug"]