import std/[unittest, json]
from std/os import getEnv
import dotenv
import ebahi

suite "ebahi tests":
  overload()

  let
    dtoken: string = os.getEnv("TOKEN")
    email: string = os.getEnv("EMAIL")
    password: string = os.getEnv("PASSWORD")


  test "email&password&mfa login":
    echo "\nebahi: EMAIL&PASSWORD LOGIN TEST"
    let request = login(email, password, 123456, totp)

    if request.code == 200:
      let
        request = getMe()
        response = response(request.body)
      echo "ebahi: logged in as = " & response["username"].getStr() & "(" & response["id"].getStr() & ")"
    else:
      echo request.body

  test "email&password login":
    echo "\nebahi: EMAIL&PASSWORD LOGIN TEST"
    let request = login(email, password)

    if request.code == 200:
      let
        request = getMe()
        response = response(request.body)
      echo "ebahi: logged in as = " & response["username"].getStr() & "(" & response["id"].getStr() & ")"
    else:
      echo request.body

  test "token login":
    echo "\nebahi: TOKEN LOGIN TEST"
    let request = login(dtoken)

    if request.code == 200:
      let response: JsonNode = response(request.body)
      echo "ebahi: logged in as = " & response["username"].getStr() & "(" & response["id"].getStr() & ")"
    else:
      echo request.body

    require(true)