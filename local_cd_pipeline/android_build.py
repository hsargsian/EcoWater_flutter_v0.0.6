import json
import boto3
import os
from urllib import request, parse
from google.oauth2 import service_account
import googleapiclient.discovery

#   Defining the scope of the authorization request
SCOPES = ['https://www.googleapis.com/auth/androidpublisher']

#   Package name for app
package_name = 'com.outcodesoftware.echowater'
SERVICE_ACCOUNT_FILE = 'serviceAccountForCD.json'
APP_BUNDLE = '../build/app/outputs/bundle/prodRelease/app-prod-release.aab'

#   This is the main handler function
def lambda_handler():
    
    #   Create a credentials object and create a service object using the credentials object
    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES
    )
    service = googleapiclient.discovery.build('androidpublisher', 'v3', credentials=credentials, cache_discovery=False)
    
    #   Create an edit request using the service object and get the editId
    edit_request = service.edits().insert(body={}, packageName=package_name)
    result = edit_request.execute()
    edit_id = result['id']
    print(edit_id)
    #   Create a request to upload the app bundle
    try:
        bundle_response = service.edits().bundles().upload(
            editId=edit_id,
            packageName=package_name,
            media_body=APP_BUNDLE,
            media_mime_type="application/octet-stream"
        ).execute()
    except Exception as err:
        message = f"There was an error while uploading a new version of {package_name}"
        print(err)
        raise err
    
    print(f"Version code {bundle_response['versionCode']} has been uploaded")

    #   Create a track request to upload the bundle to the beta track
    track_response = service.edits().tracks().update(
        editId=edit_id,
        track='beta',
        packageName=package_name,
        body={u'releases': [{
            u'versionCodes': [str(bundle_response['versionCode'])],
            u'status': u'completed',
        }]}
    ).execute()

    print("The bundle has been committed to the beta track")

    #   Create a commit request to commit the edit to BETA track
    commit_request = service.edits().commit(
        editId=edit_id,
        packageName=package_name
    ).execute()

    print(f"Edit {commit_request['id']} has been committed")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Successfully executed the app bundle release to beta')
    }

lambda_handler()