#!/bin/bash
source .env

if test ! -d "./alembic"; then
  echo "Initiating migration..."
  ./venv/bin/alembic init alembic
fi

if [[ -z "${POSTGRES_LOCAL_PORT}" ||  -z "${POSTGRES_USER}" ||  -z "${POSTGRES_PASSWORD}"|| -z "${POSTGRES_DB}" ]]; then
  echo "Missing environment variables, please set the env in .env file"
  exit 1
else
  echo "POSTGRES_LOCAL_PORT" ${POSTGRES_LOCAL_PORT}
  echo "POSTGRES_USER" ${POSTGRES_USER}
  echo "POSTGRES_PASSWORD" ${POSTGRES_PASSWORD}
  echo "POSTGRES_DB" ${POSTGRES_DB}
fi

export PGPASSWORD=${POSTGRES_PASSWORD}

# if [ $? -eq 0]; then
if psql --username ${POSTGRES_USER} -w --dbname ${POSTGRES_DB} -h localhost -p ${POSTGRES_LOCAL_PORT} -c "drop table alembic_version"; then

  MIGRATE_VERSIONS=./alembic/versions/
  if test -d "$MIGRATE_VERSIONS"; then
    echo "Migration version folder exists, deleting..."
    rm -rf ./alembic/versions/
    echo "Deleted!"
    echo "Recreating version folder for migration"
    mkdir alembic/versions
    echo "Created!"
  else
    echo "Migration version folder not exists, creating..."
    mkdir alembic/versions
    echo "Created!"
  fi
else
  echo "Something went wrong, creating database ${POSTGRES_DB}"
  psql --username ${POSTGRES_USER} -w --dbname postgres -h localhost -p ${POSTGRES_LOCAL_PORT} -c "create database ${POSTGRES_DB} encoding='utf-8'" 
  echo "Create new database ${POSTGRES_DB}"
  psql --username ${POSTGRES_USER} -w --dbname postgres -h localhost -p ${POSTGRES_LOCAL_PORT} -c "grant all privileges on database ${POSTGRES_DB} to ${POSTGRES_USER}" 
  echo "Created user ${POSTGRES_USER}"
  echo "Retry migration..."

  MIGRATE_VERSIONS=./alembic/versions/
  if test -d "$MIGRATE_VERSIONS"; then
    echo "Migration version folder exists, deleting..."
    rm -rf ./alembic/versions/
    echo "Deleted!"
    echo "Recreating version folder for migration"
    mkdir alembic/versions
    echo "Created!"
  else
    echo "Migration version folder not exists, creating..."
    mkdir alembic/versions
    echo "Created!"
  fi
fi
DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_LOCAL_PORT}/${POSTGRES_DB}"
echo "Migrate into ${DATABASE_URL}"
sed -i "/sqlalchemy.url/c\sqlalchemy.url = ${DATABASE_URL}" ./alembic.ini

./venv/bin/alembic revision --autogenerate -m "Migrate models" 
read -r -p "Are you want to commit changes to database? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    ./venv/bin/alembic upgrade head 
else
    ./venv/bin/alembic stamp head 
    echo "Canceled migration!"
fi
cat ./for_fun.txt
