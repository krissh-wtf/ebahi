import std/[httpclient, json]

var token*: string = ""
type DiscordClient* = object
  loginUrl: string = "https://discord.com/api/v9/auth/login"
  totpUrl: string = "https://discord.com/api/v9/auth/mfa/totp"
  smsUrl: string = "https://discord.com/api/v9/auth/mfa/sms"
  logoutUrl: string = "https://discord.com/api/v9/auth/logout"

  meUrl: string = "https://discord.com/api/v9/users/@me"
  # settingsUrl: string = "https://discord.com/api/v9/users/@me/settings" < way too complicated/useless for me to understand and implement

  relationshipsUrl: string = "https://discord.com/api/v9/users/@me/relationships"
  mutualRelationships: string = "https://discord.com/api/v9/users/$id/relationships"
  relationshipsInviteUrl: string = "https://discord.com/api/v9/users/@me/invites"

  guildsUrl: string = "https://discord.com/api/v9/users/@me/guilds"

const guildsMembersUrl: string = "https://discord.com/api/v9/guilds/$id/members" # % ["{ID DE SERVER}"]

type MfaMethod* = enum
    totp, sms, none

var client = newHttpClient()
client.headers = newHttpHeaders({"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/1.0.9038 Chrome/120.0.6099.291 Electron/28.2.7 Safari/537.36","Content-Type": "application/json","Authorization": token})

proc login*(self: DiscordClient, email: string, password: string, mfaMethod: MfaMethod = none, mfaCode: string = ""): string =
  let body = %*{"login": email, "password": password}

  let request = client.request(self.loginUrl, HttpPost, $body)
  let response = parseJson(request.body)

  if request.code == Http200:
      if response["mfa"].getBool() == true:
        let ticket = response["ticket"].getStr()
        let body = %*{"code": mfaCode, "ticket": ticket}

        if mfaMethod == totp:
          if response["totp"].getBool() == true:
            let request = client.request(self.totpUrl, HttpPost, $body)
            let response = parseJson(request.body)

            if request.code == Http200:
              token = $response["token"]

            return $response

        elif mfaMethod == sms:
          if response["sms"].getBool() == true:
            let request = client.request(self.smsUrl, HttpPost, $body)
            let response = parseJson(request.body)

            if request.code == Http200:
              token = $response["token"]

            return $response
        
      else:
        token = $response["token"]
        return $response

proc login*(self: DiscordClient, dToken: string): string =
  token = dToken
  # hacky way i had to make this work for some reason
  let tempHeaders = newHttpHeaders(
    {
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
      "Content-Type": "application/json",
      "Authorization": token,
    }
  )

  let request = client.request(self.meUrl, HttpGet, headers = tempHeaders)

  return $request.body

proc logout*(self: DiscordClient, token: string = token): string =
  let request = client.request(self.logoutUrl, HttpPost)

  return $request.body

proc listFriends*(self:DiscordClient, token: string = token): string =
  let request = client.request(self.relationshipsUrl, HttpGet)

  echo request.body

proc typing*(channelId: string, token: string = token): string =
  let url: string = "https://discord.com/api/v9/channels/" & channelId & "/typing"
  let request = client.request(url, HttpPost)

  return $request.body

