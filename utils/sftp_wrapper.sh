#!/bin/bash

# File: sftp_wrapper.sh
# Description: Wrapper tool for SFTP operations (upload, download, list, etc.)
# Usage:
#   ./sftp_wrapper.sh [command] [options]

# SFTP User and Server
SFTP_USER="swzhang"
SFTP_SERVER="swzhang-dev"
REMOTE_DATA_ROOT_DIR="/u/swzhang/nfs/sftp"

# Display usage instructions
function usage() {
    echo "Usage:"
    echo "  $0 upload <local_file> <remote_directory>"
    echo "  $0 download <remote_file> <local_directory>"
    echo "  $0 list <remote_directory>"
    echo "  $0 delete <remote_file>"
    echo "  $0 mkdir <remote_directory>"
    echo "  $0 rmdir <remote_directory>"
    exit 1
}

# Ensure at least two arguments are provided
if [ "$#" -lt 2 ]; then
    usage
fi

# Parse the command and its arguments
COMMAND=$1

case $COMMAND in
    "upload")
        if [ "$#" -ne 3 ]; then
            usage
        fi
        LOCAL_FILE=$2
        REMOTE_DIR="$REMOTE_DATA_ROOT_DIR/$3"

        sftp $SFTP_USER@$SFTP_SERVER <<EOF
mkdir $REMOTE_DIR
bye
EOF

        echo "Uploading $LOCAL_FILE to $REMOTE_DIR on $SFTP_SERVER..."
        sftp $SFTP_USER@$SFTP_SERVER <<EOF
put $LOCAL_FILE $REMOTE_DIR
bye
EOF
        ;;

    "download")
        if [ "$#" -ne 3 ]; then
            usage
        fi
        REMOTE_FILE="$REMOTE_DATA_ROOT_DIR/$2"
        LOCAL_DIR=$3

        echo "Downloading $REMOTE_FILE to $LOCAL_DIR..."
        sftp $SFTP_USER@$SFTP_SERVER <<EOF
get $REMOTE_FILE $LOCAL_DIR
bye
EOF
        ;;

    "list")
        if [ "$#" -ne 2 ]; then
            usage
        fi
        REMOTE_DIR="$REMOTE_DATA_ROOT_DIR/$2"

        echo "Listing contents of $REMOTE_DIR..."
        sftp $SFTP_USER@$SFTP_SERVER <<EOF
ls $REMOTE_DIR
bye
EOF
        ;;

    "delete")
        if [ "$#" -ne 2 ]; then
            usage
        fi
        REMOTE_FILE="$REMOTE_DATA_ROOT_DIR/$2"

        echo "Deleting $REMOTE_FILE..."
        sftp $SFTP_USER@$SFTP_SERVER <<EOF
rm $REMOTE_FILE
bye
EOF
        ;;

    "mkdir")
        if [ "$#" -ne 2 ]; then
            usage
        fi
        REMOTE_DIR="$REMOTE_DATA_ROOT_DIR/$2"

        echo "Creating directory $REMOTE_DIR..."
        sftp $SFTP_USER@$SFTP_SERVER <<EOF
mkdir $REMOTE_DIR
bye
EOF
        ;;

    "rmdir")
        if [ "$#" -ne 2 ]; then
            usage
        fi
        REMOTE_DIR="$REMOTE_DATA_ROOT_DIR/$2"

        echo "Removing directory $REMOTE_DIR..."
        sftp $SFTP_USER@$SFTP_SERVER <<EOF
rmdir $REMOTE_DIR
bye
EOF
        ;;

    *)
        echo "Error: Unknown command '$COMMAND'"
        usage
        ;;
esac

