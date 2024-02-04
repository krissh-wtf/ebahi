import ebahi
import std/json

let client = DiscordClient()
let credentials = parseJson(readFile("tests/other/credentials.json"))

let
    email: string = credentials["email"].getStr()
    password: string = credentials["password"].getStr()

echo client.login(email, password, "123243")