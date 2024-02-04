# ebahi
a nim library for the private discord user api

### WORK IN PROGRESS !!!!!!!!!!!!

# usage
login thru email and password:
```
import ebahi

let 
    client = DiscordClient()
    email = john@doe.com
    password = iloveyoujanedoe123

echo client.login(email, password) # if you have totp you can add your code as a third arg in the proc
```

login thru token
```
import ebahi

let 
    client = DiscordClient()
    token = "A1B2C3D4BLAGJKDL"

echo client.login(token)
```
