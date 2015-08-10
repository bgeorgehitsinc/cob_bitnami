#!/usr/bin/env bats
CONTAINER_NAME=bitnami-postgresql-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/postgresql}
SLEEP_TIME=5
POSTGRESQL_DATABASE=test_database
POSTGRESQL_ROOT_USER=postgres
POSTGRESQL_USER=test_user
POSTGRESQL_PASSWORD=test_password

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

setup() {
  cleanup_running_containers
}

teardown() {
  cleanup_running_containers
}

create_container(){
  docker run --name $CONTAINER_NAME -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

# $1 is the command
psql_client(){
  docker run --rm --link $CONTAINER_NAME:$CONTAINER_NAME -e PGPASSWORD=$POSTGRESQL_PASSWORD $IMAGE_NAME psql -h $CONTAINER_NAME "$@"
}

create_full_container(){
  docker run -d --name $CONTAINER_NAME\
   -e POSTGRESQL_USER=$POSTGRESQL_USER\
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE\
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Port 5432 exposed and accepting external connections" {
  create_container -d

  run docker run --rm --name 'linked' --link $CONTAINER_NAME:$CONTAINER_NAME\
    -e PGPASSWORD=$POSTGRESQL_PASSWORD $IMAGE_NAME\
      pg_isready -h $CONTAINER_NAME -p 5432 -t 5
  [ $status = 0 ]
}

@test "User postgres created with password" {
  create_container -d -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
  # Can not login as postgres
  run docker run --rm --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME psql -h $CONTAINER_NAME -U $POSTGRESQL_ROOT_USER -wc "\l"
  [ $status != 1 ]
  run psql_client -U $POSTGRESQL_ROOT_USER -c "\l"
  [ $status = 0 ]
}

@test "User postgres is superuser" {
  create_container -d -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
  run psql_client -U $POSTGRESQL_ROOT_USER -Axc "SHOW is_superuser;"
  [[ $output =~ "is_superuser|on" ]]
  [ $status = 0 ]
}

@test "Custom database created" {
  create_container -d -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE
  run psql_client -U $POSTGRESQL_ROOT_USER -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Can't create a custom user without database" {
  run create_container -it -e POSTGRESQL_USER=$POSTGRESQL_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_DATABASE" ]]
}

@test "Create custom user and database with password" {
  create_full_container
  # Can not login as postgres
  run docker run --rm --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME psql -h $CONTAINER_NAME -U $POSTGRESQL_ROOT_USER -wc "\l"
  [ $status != 1 ]
  run psql_client -U $POSTGRESQL_ROOT_USER -c "\l"
  [ $status != 1 ]
  run psql_client -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "\dt"
  [ $status = 0 ]
}
