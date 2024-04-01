import ebahi
import std/json

let client = DiscordClient()
let credentials = parseJson(readFile("tests/other/credentials.json"))

var 
    token: string = credentials["token"].getStr()

echo "### GET FRIENDS LIST ###"
discard client.login(token)
echo client.listFriends()