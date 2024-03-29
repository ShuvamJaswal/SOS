
import firebase_admin
from firebase_admin import credentials,messaging
import json
cred = credentials.Certificate({
  "type": "service_account",
  "project_id": "sos-app-b131f",
  "private_key_id": "8d2c08f38de3b6ba21448a2dc5b7db8c0a5470a6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQChnhz02NRGJATI\nUcw7TaF1Lb46k53fU7n7cPlJnm3QHKX2wAL5R8L9rKT1aqkEmEPjtIS/4AQz8XRn\npl5WesvYtf7ZsqdE20rxfvVtRUWgAWTtHaw1MjVMPCyVg95ib4lA/1pPtZwl7XL2\nPQyHRUpOdaaZk0nNm1n4mbMh1WNCvpHpOafIkLxQIXPXbji56dTiHzTUkdzmz1cA\nQkp6aNvoZUPd5kDXUCePoIsL105MApjSafQpc2EqLDqYaB4lpjrp6ZWhvSu6Gxcz\nbI9e8D3YUSuYD2TE2NATM/aUJalzoWyJgs24ITzcqFVLuhU7LTiWBjYKK2KIzzih\nq3AmHki5AgMBAAECggEABhRjP81YTuXT+Dp7gE+Z9Jp/6XGGzXviJynyIWmASq/e\niRBitus9fpAcCc9gBE2QtY7ONO7sZDfVCoEg/gfTMJfID9Bp/RZyv0WTXe+ZKue3\n2uOe3XFsvS1rpUQ3Urn3Y9E3SIBVxhIknPa280URV9o9JiclmO0bJABEKNBU0jyM\nUL87sAC+zPWjuKytmqNcHnwxQJdbTAdUe8Bwe+iRrm/D0cr1CTUepElnmJJCQ+mI\n5YMFlIH70+T2vq9d9hOebjlcRExNYqepsq2KxL6AQmKBWi3e6SItPu7PJ3xLM2w8\nunDXn1D9Ws4pSfXVYQF75xGnzR4E8RpmUsZ+lBa2cQKBgQDamWvbRq53OdrB4Qxh\njS1rgrFaFU6tZCpzDt1SIDaoVEfWvnfaD+053f516C9R/76HhqsLOpg892Gpt5zX\nZzvbN5sjSXH3CpWh5xzWK+EyVczWd5AkXtSpDi2Wp3xBQbz8Z4bFjZCxvqAVkGVW\nBZ4tVdAZx5RBg1cr18BoTU0qhwKBgQC9ROm4pkCK1DAx7giUGI9nqIAE5NvFy8Bj\nsTHbPbQuspAbsGFeu0FwP2eHb1YA6xettWTfA2RzwJ+l9Z6glqdhBzMwi71BQTQm\nRm/VNN2DUX6Ld82kMC723HPQHDVhlB0wKotBVLqztJTE6UAMK9i+xGktsbe6hMac\ny+jzpDWCvwKBgEVP2C8S3kbXhVFsNizIQtqP+gQCNYws8njBAdQEetAsyQqCIiZ2\nXlW22fQwxrBNUvBN9vX8gkDyf3j8yzJRfV0o6Hvr0cLvDDrluPL/vsvjAKwQBRhD\nKVLhN/tI59EZMv8lJEqHdJWnR8MOodMAvQLK7sz9xzhumLlCE7P+rrUJAoGAJ42/\nSld0JY8ygzy7jjeTwJX2Kw+o3i02h58ATFEY1ql6dE7oCmQXyN13RVZ/IrH+wM6n\nxfNvisE2m/g4rlbNo/ldOUf6xShbPaR6upPRtx/Q0lS3JRjst6paiaNbhIjvkKFT\neNO8MNIMRRp5yBFhunxRfrslKlWVLC9w/3nRtQECgYB2qj8trBrKURFQem47PQwB\n7AO8NfZjWsfD/QPPQMa9mFaxEDaaaFI6bNJ2dM6ICDIJIICmt32owfykMMn9bsaK\n16s4FhCJFIbuncJNDYQ4T4JHoKroZbWRHkbY+FbAbcKnBXBxRq103tuHyNjraEb7\n2oSLeVDnma24uRoz5EUKcQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-bwuul@sos-app-b131f.iam.gserviceaccount.com",
  "client_id": "113760847512986539516",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-bwuul%40sos-app-b131f.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
)
firebase_admin.initialize_app(cred)

from flask import Flask,request
app=Flask(__name__)
@app.route('/')
def root():
	return 'Working'
@app.route('/send',methods=['POST'])
def send():
    # print(request.data)
    print(json.loads(request.data)['list'])
    a=messaging.MulticastMessage(json.loads(request.data)['list'],notification=messaging.Notification(
   title='Emergency',
   body='Someone needs your help.'
  ),
android=messaging.AndroidConfig(priority='high'),
                           data={ 'requestId': json.loads(request.data)['requestId'],'userId': json.loads(request.data)['userId']})
    s=messaging.send_multicast(a)
    for i in s.responses:
        print(i.success)
    return str(s)
# messaging.BatchResponse.responses
# if __name__ == '__main__':
#     app.run()