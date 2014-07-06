#!/bin/bash
start=`date +%s`

HOST="deploy@rdio-sync.com"
APP_DIR=/home/deploy/apps/rdio-sync
LOG_DIR=$APP_DIR/log
CURRENT_DIR=$APP_DIR/current
DESTINATION_DIR=$APP_DIR/releases/`date +%Y-%m-%d-%H-%M-%S`

function locally_do(){
  COMMAND=$@
  $COMMAND
  if [ $? -ne 0 ]; then
      echo "Failed to run: '$COMMAND'"
      exit 1
  fi
}

function over_ssh_do(){
  COMMAND=$@
  ssh $HOST "$COMMAND"
  if [ $? -ne 0 ]; then
      echo "Failed to run: '$COMMAND'"
      exit 1
  fi
}

function rsync_project(){
  rsync -a -v --exclude=node_modules --exclude=.git -e "ssh" . $HOST:$DESTINATION_DIR
  if [ $? -ne 0 ]; then
      exit 1
  fi
}

echo "compiling locally"
locally_do "cake build"
echo "creating directories"
over_ssh_do "mkdir -p $APP_DIR/releases $APP_DIR/log $APP_DIR/forever"
echo "starting rsync"
rsync_project
echo "npm install"
over_ssh_do "cd $DESTINATION_DIR && npm install --production"
echo "gzipping assets"
over_ssh_do "cd $DESTINATION_DIR/public && \
  for f in \$(find .); do \
    gzip -9 -c \$f > \$f.gz; \
  done"
echo "linking current"
over_ssh_do "ln -nsf $DESTINATION_DIR $CURRENT_DIR"
echo "Restarting Service"

over_ssh_do "forever restart \
  -l $LOG_DIR/forever.log \
  -o $LOG_DIR/rdio-sync.log \
  -e $LOG_DIR/rdio-sync.log \
  --append \
  -p $APP_DIR/forever \
  -c coffee $CURRENT_DIR/src/application.coffee"


end=`date +%s`
runtime=$((end-start))
echo "Deployed in ${runtime} seconds"

