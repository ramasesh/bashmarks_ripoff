export BASHMARK_FILE=~/.bashmarks
touch $BASHMARK_FILE

function _bookmark_name_valid {
  exit_message=""
  if [ -z $1 ]; then #TODO: What is -z?
    exit_message="bookmark name required"
    echo $exit_message
  elif [ $1 != `echo $1 | sed 's/[^a-zA-Z1-9]//g'` ]; then
    exit_message="bookmark name invalid (alphanumeric characters allowed only)"
    echo $exit_message
  fi
}

function try_name {
  _bookmark_name_valid $1
  echo "Ready for the exit message? Here it comes:"
  echo $exit_message
}

function bashmark {
  if [ -z $1 ]; then
    echo "A name must be provided for the bashmark"
  else
    echo "Bashmark will be set"
    echo "Bashmark: $1 will now point to $PWD"
    echo "$1:$PWD" >> $BASHMARK_FILE
  fi
}

function gotobashmark {
  if [ -z $1 ]; then 
    echo "A bashmark name must be provided to go to"
  else
    check_if_bashmark $1
    if [ -z $pointed_directory ]; then 
      echo "Sorry, bashmark was not valid"
    else
      cd $pointed_directory
    fi
  fi
}

function list_bashmarks {
  cat $BASHMARK_FILE | cut -d':' -f 1
}

function check_if_bashmark {
  if [ -z $1 ]; then 
    echo "A man needs a name" 
  else
    if [ `cat $BASHMARK_FILE | grep ^$1: | wc -l` == 1 ]; then
      echo "We have a valid bashmark!"
      cat $BASHMARK_FILE | grep ^$1: | cut -d':' -f 2
      pointed_directory=`cat $BASHMARK_FILE | grep ^$1: | cut -d':' -f 2`
    else
      echo "We don't have a valid bashmark!"
      unset pointed_diretory
    fi
  fi
}

function delete_bashmark {
  if [ -z $1 ]; then 
    echo "You didn't give me a bashmark to delete!"
  else 
    check_if_bashmark $1
    if [ -z $pointed_directory ]; then
      echo "The bashmark you wanted me to delete is not valid"
    else 
      echo "Deleting bashmark"
      cat $BASHMARK_FILE | sed "/^$1:/d" > tempfile
      mv tempfile $BASHMARK_FILE
    fi
  fi
}

