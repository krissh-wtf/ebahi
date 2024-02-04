import ebahi
import std/json

let client = DiscordClient()
let credentials = parseJson(readFile("tests/other/credentials.json"))

var 
    token: string = credentials["token"].getStr()

echo client.login(token)