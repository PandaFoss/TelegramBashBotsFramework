#!/usr/bin/env sh

################################################################################
#                        Telegram Bash Bot Framework                           #
# ---------------------------------------------------------------------------- #
# Description: Minimal but useful implementation of the Telegram Bot API       #
#              written entirely in Bash.                                       #
# Authors: Panda Foss <https://github.com/PandaFoss>                           #
#          Mati Chewer <https://github.com/matichewer>                         #
# License: MIT                                                                 #
################################################################################
#==== DEFAULT VARIABLES =======================================================#
# Mode for parsing entities in the message text (Method: sendMessage)
PARSE_MODE="Markdown"
# Disables link previews for links in this message (Method: sendMessage)
PREVIEW="false"
# Sends the message silently. (Method: forwardMessage)
DISABLE_NOTIFICATION="false"
#==== END DEFAULT VARIABLES ===================================================#

#==== CONFIG ==================================================================#
# User-wide configuration file
readonly USER_CONFIG="${HOME}/.tbbrc"
# System-wide configuration file
readonly SYSTEM_CONFIG="/etc/tbb/tbb.rc"
# Maximum time in seconds that you allow the whole operation to take
readonly TIMEOUT=20
# shellcheck source=/etc/tbb/tbb.rc disable=SC1091
[ -f "${SYSTEM_CONFIG}" ] && . "${SYSTEM_CONFIG}"
# shellcheck source=${HOME}/.tbbrc disable=SC1091
[ -f "${USER_CONFIG}" ] && . "${USER_CONFIG}"
# Telegram API link with bot token
readonly URL="https://api.telegram.org/bot${BOT_TOKEN}"
#==== END CONFIG ==============================================================#

#==== FUNCTIONS ===============================================================#

# Def: Parses function arguments
# Return KEY, VALUE
# $1: string "key:value" to parse
parse_args() {
  KEY="${1%%:*}"
  VALUE="${1#*:}"
}

# Def: Show unknown argument and exit with error
# $1: unkwnown argument
unknown_argument() {
  echo "Unknown argument: $1" && exit 4
}
#==== END FUNCTIONS ===========================================================#

#==== API METHODS =============================================================#

# Method: getMe
# API Doc: https://core.telegram.org/bots/api#getme
getMe() {
  # Get basic information about the bot
  curl --silent "${URL}/getMe"
}
# Method: logOut
# API Doc: https://core.telegram.org/bots/api#logout
logOut() {
  # Log out from the cloud Bot API server
  curl --silent "${URL}/logOut"
}

# Method: forwardMessage
# API Doc: https://core.telegram.org/bots/api#forwardmessage
forwardMessage() {
  # Parse arguments
  for arg in "$@"; do
    parse_args "${arg}"
    case "${KEY}" in
      chat_id)
        CHAT_ID="${VALUE}"
        ;;
      from_chat_id)
        FROM_CHAT_ID="${VALUE}"
        ;;
      disable_notification)
        DISABLE_NOTIFICATION="${VALUE}"
        ;;
      message_id)
        MESSAGE_ID="${VALUE}"
        ;;
      *)
        unknown_argument "${KEY}"
        ;;
    esac
  done
  # Check required options
  [ -z "${CHAT_ID}" ] && echo "Error: Missing chat_id" && exit 3
  [ -z "${FROM_CHAT_ID}" ] && echo "Error: Missing from_chat_id" && exit 3
  [ -z "${MESSAGE_ID}" ] && echo "Error: Missing message_id" && exit 3
  # Forward message
  curl --silent "${URL}/forwardMessage"                                        \
    --max-time "${TIMEOUT}"                                                    \
      --data "chat_id=${CHAT_ID}"                                              \
      --data "from_chat_id=${FROM_CHAT_ID}"                                    \
      --data "disable_notification=${DISABLE_NOTIFICATION}"                    \
      --data "message_id=${MESSAGE_ID}"
}

# Method: sendMessage
# API Doc: https://core.telegram.org/bots/api#sendmessage
sendMessage() {
  # Parse arguments
  for arg in "$@"; do
    parse_args "${arg}"
    case "${KEY}" in
      text)
        TEXT="${VALUE}"
        ;;
      chat_id)
        CHAT_ID="${VALUE}"
        ;;
      parse_mode)
        PARSE_MODE="${VALUE}"
        ;;
      disable_web_page_preview)
        PREVIEW="${VALUE}"
        ;;
      *)
        unknown_argument "${KEY}"
        ;;
    esac
  done
  # Check required options
  [ -z "${CHAT_ID}" ] && echo "Error: Missing chat_id" && exit 3
  [ -z "${TEXT}" ] && echo "Error: Missing text" && exit 3
  # Send message
  curl --silent "${URL}/sendMessage"                                           \
    --max-time "${TIMEOUT}"                                                    \
    --data-urlencode "text=${TEXT}"                                            \
      --data "chat_id=${CHAT_ID}"                                              \
      --data "disable_web_page_preview=${PREVIEW}"                             \
      --data "parse_mode=${PARSE_MODE}"
}
#==== END API METHODS =========================================================#
#==== MAIN ====================================================================#
#==== END MAIN ================================================================#
