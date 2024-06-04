# ebahi
a nim library for the private discord user api

### WORK IN PROGRESS !!!!!!!!!!!!

# usage
login thru email and password (supports mfa if needed):
```
import ebahi

let 
    request = login("john@doe.net", "coolboy123", 123456, totp)
    response = response(request.body)

echo "logged in as: " & response["username"]
```

login thru token
```
import ebahi

let 
    request = login("A1B2C3D4BLAGJKDL")
    response = response(request.body)

echo "logged in as: " & response["username"]
```
