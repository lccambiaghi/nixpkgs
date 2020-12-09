#!/usr/bin/env python3

import json
import fileinput
from json import JSONDecodeError

red_color = "\033[31m"
green_color = "\033[32m"
yellow_color = "\033[33m"
disable_color = "\033[00m"
blue_color= "\033[034m"
cyan_color = "\033[036m"
red_intense_color = '\033[91m'

error_level_colors = {
    "ERROR": red_color,
    "WARNING": yellow_color,

}

timestamp_names = ["timestamp", "time"]
message_names = ["message", "msg"]

def get_key_from_list(dictionary, key_list):
    for key in key_list:
        timestamp = dictionary.get(key)
        if timestamp is not None:
            return timestamp
    else:
        raise Exception("No timestamp")



for line in fileinput.input():
    try:
        parsed_line = json.loads(line)
        timestamp = get_key_from_list(parsed_line, timestamp_names)
        message = get_key_from_list(parsed_line, message_names)
        time_color = error_level_colors.get(parsed_line.get('level', ""), cyan_color)

        print(f"{time_color}{timestamp}{disable_color} ", parsed_line.get('level', ""), message )
        if parsed_line.get("exc_info"):
            print(red_intense_color, parsed_line.get("exc_info"), disable_color)

    except JSONDecodeError as e :
        print("\033[91m>\033[00m", line.strip('\n'))
    except Exception as e:
        print(f"\033[91m{repr(e)}\033[00m",)
        print("\033[91m>\033[00m", line.strip('\n'))
