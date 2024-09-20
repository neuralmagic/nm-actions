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
import pathlib
import subprocess

if __name__ == "__main__":

    # command line arguments
    args_parser = argparse.ArgumentParser()

    args_parser.add_argument(
        "-j",
        "--resources_json",
        help="string version of JSON identifying resource fields",
        type=str)

    args_parser.add_argument(
        "-d",
        "--destination",
        help="filepath relative to REPO root to generate the file,"
             " default 'testmo_resources.json'.",
        default='testmo_resources.json',
        type=str)

    args = args_parser.parse_args()
    fields = json.loads(args.resources_json)

    for field in fields:
        testmo_args = {
            "resources": args.destination,
            "name": field,
            "type": "string",
            "value": fields[field]
        }
        testmo_command = "npx testmo automation:resources:add-field " + \
                         " ".join([f"--{k} {v}"
                                   for k, v in testmo_args.items()])

        # run the command and raise any exceptions
        result = subprocess.run(
            testmo_command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
            cwd=pathlib.Path.cwd(),
            shell=True
        )
