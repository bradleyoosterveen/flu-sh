#!/bin/bash

function flu() {
    case $1 in
        "get")
            fvm dart pub get
            return 0
            ;;
        "clean")
            fvm flutter clean && fvm dart run build_runner clean && fvm flutter pub cache clean
            return 0
            ;;
        "gen_index")
            fvm dart run index_generator
            return 0
            ;;
        "gen_loc")
            fvm dart run lokalise_flutter_sdk:gen-lok-l10n
            return 0
            ;;
        "runner")
            case $2 in
                "build")
                    fvm dart run build_runner build --delete-conflicting-outputs
                    return 0
                    ;;
                "watch")
                    fvm dart run build_runner watch --delete-conflicting-outputs
                    return 0
                    ;;
                *)
                    echo "Invalid option for build_runner"
                    return 1
                    ;;
            esac
            ;;
        "format")
            fvm dart format . && fvm dart fix --apply
            return 0
            ;;
        "build_and_install")
            fvm flutter build apk --release && fvm flutter install
            return 0
            ;;
        "run")
            scripts=(
                "flu get"
                "flu clean"
                "flu gen_index"
                "flu gen_loc"
                "flu runner build"
                "flu runner watch"
                "flu format"
                "flu build_and_install"
            )

            # add ability to run a script by number by typing the number directly
            if [[ -z "$2" ]]; then
                echo "No script provided. Please select a script to run:"
            else
                # check if the script is a number
                if [[ "$2" =~ ^[0-9]+$ ]]; then
                    script=$2
                    if (( script < 1 || script > ${#scripts[@]} )); then
                        echo "Invalid choice. Please select a valid script number."
                        return 1
                    fi
                    script=$((script))
                    echo "Running script: ${scripts[$script]}"
                    eval "${scripts[$script]}"
                    return 0
                fi
            fi

            echo "Available scripts:"
            for i in "${scripts[@]}"; do
                ((count++))
                echo "$count: $i"
            done

            count=0

            echo -n "Enter the script number: "
            read -r script

            if [[ -z "$script" ]]; then
                echo "No input provided. Please enter a number."
                return 1
            fi
            if ! [[ "$script" =~ ^[0-9]+$ ]]; then
                echo "Invalid input. Please enter a number."
                return 1
            fi
            if (( script < 1 || script > ${#scripts[@]} )); then
                echo "Invalid choice. Please select a valid script number."
                return 1
            fi
            script=$((script))
            echo "Running script: ${scripts[$script]}"
            eval "${scripts[$script]}"
            return 0
            ;;
        *)
            echo "Invalid option"
            ;;
        esac
}