import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ROOT_FOLDER = "/mnt/efs"

def lambda_handler(event, context):
  directories = os.listdir(ROOT_FOLDER)
  directories.sort(key=lambda x: os.path.getmtime(f"{ROOT_FOLDER}/{x}"), reverse=True)  #Sort by Modification Time

  for directory in directories:
    for filename in os.listdir(f"{ROOT_FOLDER}/{directory}"):
      file_path = os.path.join(f"{ROOT_FOLDER}/{directory}", filename)
      with open(file_path, 'r') as file:
        data = json.load(file)

      scanFindings = data.get('scanFindings')
      if (scanFindings == None):
        print(directory + "/" + filename + ": Scan is clear")
      else:
        print(directory + "/" + filename + ": Virus detected!")

  return {"statusCode": 200, "body": f"Finished scanning all folders"}
