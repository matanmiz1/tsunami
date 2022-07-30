import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ROOT_FOLDER = "/mnt/efs"

def lambda_handler(event, context):
  files = os.listdir(ROOT_FOLDER)
  files.sort(key=lambda x: os.path.getmtime(f"{ROOT_FOLDER}/{x}"), reverse=True)  #Sort by Modification Time
  last_folder=files[0]

  for filename in os.listdir(f"{ROOT_FOLDER}/{last_folder}"):
    file_path = os.path.join(f"{ROOT_FOLDER}/{last_folder}", filename)
    with open(file_path, 'r') as file:
      data = json.load(file)

    scanFindings = data.get('scanFindings')
    if (scanFindings == None):
      print(filename + ": Scan is clear")
    else:
      print(filename + ": Virus detected!")

    return {"statusCode": 200, "body": f"Finished scanning {last_folder}"}
