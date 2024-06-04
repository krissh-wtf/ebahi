import std/[json, strutils]
import discord
import puppy

# helper for puppy
proc request(url, verb: string, headers = emptyHttpHeaders(), body: sink string = ""): Response = 
  if verb == "POST":
    let request = newRequest(url, "POST", headers, 60)
    request.body = body
    return fetch(request)
  else:
    return fetch(newRequest(url, verb, headers, 60))

# helper proc to extract values from keys in response json
proc response*(json: string): JsonNode =
  return parseJson(json)

# email & password login
proc login*(email, password: string; mfaCode: int = 0, mfaMethod: MfaMethod = none): Response =
  let 
    body = %*{"login": email, "password": password}
    request: Response = request(loginUrl, "POST", @[("User-Agent", userAgent),("Content-Type", contentType)], $body)
    response: JsonNode = response(request.body)

  if request.code == 200 and response.contains("token"):
    token = response["token"].getStr()
    return request

  elif request.code == 200 and response.contains("mfa") and response["mfa"].getBool() == true:
    let body = %*{"code": $mfaCode, "ticket": response["ticket"].getStr()}

    if mfaMethod == totp and response["totp"].getBool() == true:
      let
        request: Response = request(totpUrl, "POST", @[("User-Agent", userAgent),("Content-Type", contentType)], $body)
        response: JsonNode = response(request.body)

      if request.code == 200: token = response["token"].getStr()

      return request

    elif mfaMethod == sms and response["sms"].getBool() == true:
      let 
        request: Response = request(smsUrl, "POST", @[("User-Agent", userAgent),("Content-Type", contentType)], $body)        
        response: JsonNode = response(request.body)

      if request.code == 200: token = response["token"].getStr()

      return request

# token login
proc login*(dToken: string = token): Response =
  let 
    request: Response = request(meUrl, "GET", @[("User-Agent", userAgent),("Content-Type", contentType),("Authorization", token)])

  if request.code == 200: token = dToken

  return request

# logout
proc logout*(): Response =
  let request: Response = request(logoutUrl, "POST", @[("User-Agent", userAgent),("Content-Type", contentType),("Authorization", token)])

  return request

# get me
proc getMe*(): Response =
  let request: Response = request(meUrl, "GET", @[("User-Agent", userAgent),("Content-Type", contentType),("Authorization", token)])

  return request

# get servers
proc getServer*(): Response =
  let request = request(guildsUrl, "GET", @[("User-Agent", userAgent),("Content-Type", contentType),("Authorization", token)])

  return request

# get all friernds
proc getFriends*(): Response =
  let request = request(relationshipsUrl, "GET", @[("User-Agent", userAgent),("Content-Type", contentType),("Authorization", token)])

  return request

# typing state
proc typing*(channelId: string, token: string = token): Response =
  let request: Response = request(typingUrl % [channelId], "POST", @[("User-Agent", userAgent),("Content-Type", contentType),("Authorization", token)])

  return request