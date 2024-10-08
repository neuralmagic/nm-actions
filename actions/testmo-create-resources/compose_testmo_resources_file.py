#! /usr/bin/env python

# Script to create a TestMo "resources" file containing a specified
# set of fields.  The fields are passed in as JSON with the key being the name
# of the field, and it's value being the value of the field.
# Warning; only "string" type fields are supported here.
# see these references for details about the use of TestMo resources files:
# https://docs.testmo.com/docs/automation/reference#submitting-threads-for-runs
# https://docs.testmo.com/docs/automation/reference#adding-fields-links-and-artifacts

import argparse
import json
import subprocess

if __name__ == "__main__":
    # command line arguments
    args_parser = argparse.ArgumentParser()

    args_parser.add_argument(
        "-j",
        "--resources_json",
        help="string version of JSON identifying resource fields",
        type=str,
    )

    args_parser.add_argument(
        "-d",
        "--destination",
        help="absolute path for where to generate the file,",
        type=str,
    )

    args = args_parser.parse_args()
    fields = json.loads(args.resources_json)

    for field in fields:
        testmo_args = [
            "--resources",
            f"{args.destination}",
            "--name",
            f"{field}",
            "--type",
            "string",
            "--value",
            f"{fields[field]}",
        ]
        testmo_command = ["npx", "testmo", "automation:resources:add-field"]
        full_command = testmo_command + testmo_args

        # run the command and raise any exceptions
        subprocess.run(full_command, check=True)
