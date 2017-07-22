#!/usr/bin/env bash
set -e

while [[ $# -gt 1 ]]
do
  KEY="$1"

  case $KEY in
      -h|--hostname)
        PRANK_HOSTNAME="$2"
        shift
      ;;
      -t|--pagetitle)
        PAGE_TITLE="$2"
        shift
      ;;
      -m|--imagemime)
        IMAGE_MIME="$2"
        shift
      ;;
      -i|--imagpath)
        IMAGE_PATH="$2"
        shift
      ;;
      *)
        >&2 echo "Unknown option: $KEY"
        exit 1
      ;;
  esac
  shift
done

MISSING_ARG=0
if [ -z "$PRANK_HOSTNAME" ]; then
  >&2 echo "Missing argument: -h|--hostname"
  MISSING_ARG=1
fi
if [ -z "$PAGE_TITLE" ]; then
  >&2 echo "Missing argument: -t|--pagetitle"
  MISSING_ARG=1
fi
if [ -z "$IMAGE_MIME" ]; then
  >&2 echo "Missing argument: -m|--imagemime"
  MISSING_ARG=1
fi
if [ -z "$IMAGE_PATH" ]; then
  >&2 echo "Missing argument: -i|--imagpath"
  MISSING_ARG=1
fi

if [ "$MISSING_ARG" -eq 1 ]; then
  exit 2
fi

UUID="$(uuidgen)"
IMAGE_BASE64="$(base64 $IMAGE_PATH | tr -d '\n')"

PAGE_HTML=$(cat page.html.template | \
            sed -e "s@{{page_title}}@$PAGE_TITLE@" | \
            sed -e "s@{{image_mime}}@$IMAGE_MIME@" | \
            sed -e "s@{{image_base64}}@$IMAGE_BASE64@")

HTTP_SERVER_CODE=$(cat http_server.py.template | \
                   sed -e 's@\\n@#newline#@' |
                   sed -e "s@{{hostname}}@$PRANK_HOSTNAME@" |
                   sed -e "s@{{page_html}}@${PAGE_HTML//$'\n'/\\n}@")

PRANK_BASE_CODE=$(cat prank_base.sh.template | \
                  sed -e "s@{{uuid}}@$UUID@" |
                  sed -e "s@{{hostname}}@$PRANK_HOSTNAME@" |
                  sed -e "s@{{http_server_code}}@${HTTP_SERVER_CODE//$'\n'/\\n}@" |
                  sed -e 's@#newline#@\\n@')

PRANK_BASE64=$(echo "$PRANK_BASE_CODE" | base64)
PRANK_CODE=$(cat prank.sh.template | \
             sed -e "s@{{prank_base64}}@${PRANK_BASE64//$'\n'/\\n}@")

echo "$PRANK_CODE"
