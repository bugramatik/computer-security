# Encode the payload
encoded_payload=$(base64 payload01.yaml)

# Curl command to send the payload
curl -X POST localhost:8080/api/load \
     -H "Content-Type: multipart/form-data" \
     -F "data=$encoded_payload"
