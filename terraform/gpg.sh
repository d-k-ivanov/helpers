#!/bin/bash
# Encrypt or decrypt protected files.
# Platform: Unix
# Author:   Dmitry Ivanov

f_usage() {
  local Y="\033[0;33m"    # yellow
  local ZZ="\033[0m"      # Reset
	printf "${Y}Usage: $(basename $0) <option>${ZZ}\n\n"
	printf "${Y}  Options:
    [e]ncrypt
    [d]ecrypt${ZZ}\n"
}

declare -a secured_files=(
  "secrets/key1.key"
  "secrets/key2.key"
  "secrets/key3.key"
  "secrets/key4.txt"
)

declare -a recipients=()
for key in `ls gpg`; do
  recipients+="-r $(basename ${key}) "
done


case $1 in
	e|encrypt )
		shift
    for file in "${secured_files[@]}"; do
      printf "\033[0;32mEncrypting $file\033[0m\n"
      gpg -e --yes --trust-model always $recipients $file
    done
		;;

	d|decrypt )
		shift
    for file in "${secured_files[@]}"; do
      printf "\033[0;32mDecrypting $file\033[0m\n"
      gpg --output $file --decrypt $file.gpg
    done
		;;

  * )
		f_usage
		;;
esac

echo
exit 0
