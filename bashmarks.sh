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
    echo "A name must be provided for the bashmark" > /dev/tty
  else
    echo "Bashmark will be set" > /dev/tty
    echo "Bashmark: $1 will now point to $PWD" > /dev/tty
    echo "$1:$PWD" >> $BASHMARK_FILE
  fi
}

function gotobashmark {
  if [ -z $1 ]; then 
    echo "A bashmark name must be provided to go to" > /dev/tty
  else
    check_if_bashmark $1
    if [ -z "$pointed_directory" ]; then 
      echo "Sorry, bashmark was not valid" > /dev/tty
    else
      if [ -d "$pointed_directory" ]; then 
        cd $pointed_directory
        if [ ! $? -eq 0 ]; then
          echo "Changing into the bashmark directory seems to have failed." > /dev/tty
          echo "   You might want to check which directory you are in." > /dev/tty
          echo "   This is likely a permissions issue." > /dev/tty
        fi 
      else
        echo "The directory the bashmark referred to, $pointed_directory, must no longer exist" > /dev/tty
      fi
    fi
  fi
}

function list_bashmarks {
  cat $BASHMARK_FILE | grep -v COMMAND_SHORTCUT | cut -d':' -f 1
}

function check_if_bashmark {
  if [ -z $1 ]; then 
    echo "A man needs a name" > /dev/tty
  else
    if [ `cat $BASHMARK_FILE | grep ^$1: | wc -l` == 1 ]; then
      echo "We have a valid bashmark!" > /dev/tty
      cat $BASHMARK_FILE | grep ^$1: | cut -d':' -f 2
      pointed_directory=`cat $BASHMARK_FILE | grep ^$1: | cut -d':' -f 2`
    else
      echo "We don't have a valid bashmark!" > /dev/tty
      unset pointed_diretory
    fi
  fi
}

function delete_bashmark {
  if [ -z $1 ]; then 
    echo "You didn't give me a bashmark to delete!" > /dev/tty
  else 
    check_if_bashmark $1
    if [ -z $pointed_directory ]; then
      echo "The bashmark you wanted me to delete is not valid" > /dev/tty
    else 
      echo "Deleting bashmark" > /dev/tty
      cat $BASHMARK_FILE | sed "/^$1:/d" > tempfile
      mv tempfile $BASHMARK_FILE
    fi
  fi
}

function bashmark_shortcut {
  if [ $# -eq 0 ]; then
    # without arguments, lists all the current bashmark shortcuts
    echo "Current bashmark shortcuts:" > /dev/tty
    cat $BASHMARK_FILE | grep COMMAND_SHORTCUT | cut -d" " -f2,3 | tr " " ":"
  else
    if [ $# -eq 2 ]; then
      # if two arguments are provided, then we update the bashmark
      # either the shortcutis there already, or it is not
      if [ "gotobashmark" == $1 ] || [ "list_bashmarks" == $1 ] || [ "delete_bashmark" == $1 ] || [ "bashmark" == $1 ]; then
        # TODO For the above condition, there should be a way to write it more cleanly
        # with a grep, but I couldn't get it to work earlier.
        echo "Setting bashmark shortcut for command $1" > /dev/tty

        # check if there was an old alias, and if so, unalias it
        old_alias=`grep "COMMAND_SHORTCUT $1" $BASHMARK_FILE | cut -d" " -f3`
        echo "Old alias, which will now be unaliased, was $old_alias" > /dev/tty
        unalias $old_alias 2> /dev/null

        cat $BASHMARK_FILE | grep -v "COMMAND_SHORTCUT $1" > $BASHMARK_FILE.tmp
        echo "COMMAND_SHORTCUT $1 $2" >> $BASHMARK_FILE.tmp
        mv $BASHMARK_FILE.tmp $BASHMARK_FILE

        # Now set new alias
        alias $2=$1
        echo "New alias is $2" > /dev/tty
      else
        echo "First argument must be one of [gotobashmark, list_bashmarks, delete_bashmark]" > /dev/tty
        exit 1
      fi 
    fi 
  fi
}

